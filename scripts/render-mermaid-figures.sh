#!/usr/bin/env bash
# Render figures/*.mmd → figures/*.png for a technical report (PDF-safe Mermaid).
#
# Quarto's built-in Mermaid→PNG path uses headless Chrome and hangs on GitHub Actions.
# Pre-render with @mermaid-js/mermaid-cli instead; HTML output can still use live Mermaid.
#
# Usage: ./scripts/render-mermaid-figures.sh [REPORT_ID]
# Example: ./scripts/render-mermaid-figures.sh SF-TR-2026-001

set -euo pipefail

REPORT_ID="${1:-}"
if [ -z "$REPORT_ID" ]; then
  echo "Usage: $0 REPORT_ID" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FIG_DIR="$ROOT/reports/$REPORT_ID/figures"

if [ ! -d "$FIG_DIR" ]; then
  echo "No figures directory: $FIG_DIR (nothing to render)"
  exit 0
fi

shopt -s nullglob
MMD_FILES=("$FIG_DIR"/*.mmd)
if [ ${#MMD_FILES[@]} -eq 0 ]; then
  echo "No .mmd files in $FIG_DIR"
  exit 0
fi

# A4 text width at 11pt with 25mm margins ≈ 5.8in → 1740px at 300dpi scaled for PNG embed
WIDTH="${MERMAID_FIGURE_WIDTH:-1400}"
HEIGHT="${MERMAID_FIGURE_HEIGHT:-1200}"
BACKGROUND="${MERMAID_BACKGROUND:-white}"

render_one() {
  local mmd="$1"
  local base="${mmd%.mmd}"
  local out="${base}.png"
  echo "Rendering $(basename "$mmd") → $(basename "$out") (${WIDTH}x${HEIGHT})"

  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    docker run --rm \
      -v "$FIG_DIR:/data" \
      -u "$(id -u):$(id -g)" \
      minlag/mermaid-cli \
      -i "/data/$(basename "$mmd")" \
      -o "/data/$(basename "$out")" \
      -w "$WIDTH" -H "$HEIGHT" -b "$BACKGROUND"
    return
  fi

  npx --yes @mermaid-js/mermaid-cli@11.4.0 \
    -i "$mmd" \
    -o "$out" \
    -w "$WIDTH" -H "$HEIGHT" -b "$BACKGROUND"
}

for mmd in "${MMD_FILES[@]}"; do
  render_one "$mmd"
done

echo "Done. Rendered ${#MMD_FILES[@]} Mermaid figure(s) for $REPORT_ID."
