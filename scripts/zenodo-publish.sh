#!/usr/bin/env bash
# Create a new Zenodo deposition for a first-time SF-TR report and upload release assets.
# Requires a personal access token: https://zenodo.org/account/settings/applications/tokens/new/
# Scopes: deposit:write, deposit:actions
#
# Usage:
#   export ZENODO_ACCESS_TOKEN=...
#   ./scripts/zenodo-publish.sh SF-TR-2026-002 SF-TR-2026-002-v1.0.0
#
# Optional:
#   ZENODO_PUBLISH=true   — publish immediately and print version DOI
set -euo pipefail

REPORT_ID="${1:?Report ID required}"
RELEASE_TAG="${2:?Release tag required}"
ZENODO_API="${ZENODO_API:-https://zenodo.org/api}"
ZENODO_BASE="${ZENODO_API%/api}"
TOKEN="${ZENODO_ACCESS_TOKEN:?Set ZENODO_ACCESS_TOKEN}"
PUBLISH="${ZENODO_PUBLISH:-false}"
REPO="${GITHUB_REPO:-SynapticFour/technical-reports}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI required to download release assets" >&2
  exit 1
fi

if ! gh release view "${RELEASE_TAG}" --repo "${REPO}" >/dev/null 2>&1; then
  echo "ERROR: GitHub release '${RELEASE_TAG}' not found on ${REPO}." >&2
  exit 1
fi

download_release_asset() {
  local asset="$1"
  local dest="/tmp/${asset}"
  rm -f "$dest"
  if gh release download "${RELEASE_TAG}" --repo "${REPO}" --pattern "${asset}" --dir /tmp --clobber 2>/dev/null \
    && [ -f "$dest" ]; then
    echo "$dest"
    return 0
  fi
  local url="https://github.com/${REPO}/releases/download/${RELEASE_TAG}/${asset}"
  if curl -fsSL -o "$dest" "$url"; then
    echo "$dest"
    return 0
  fi
  return 1
}

resolve_release_asset() {
  local label="$1"
  shift
  local candidate path
  for candidate in "$@"; do
    if path=$(download_release_asset "${candidate}"); then
      echo "$path"
      return 0
    fi
  done
  echo "ERROR: Could not download ${label} from release ${RELEASE_TAG} (tried: $*)" >&2
  exit 1
}

PDF_PATH=$(resolve_release_asset "PDF" "${REPORT_ID}.pdf" "paper.pdf")
HTML_PATH=$(resolve_release_asset "HTML" "${REPORT_ID}.html" "paper.html")
echo "Downloaded release assets:"
echo "  ${PDF_PATH} ($(wc -c < "$PDF_PATH") bytes)"
echo "  ${HTML_PATH} ($(wc -c < "$HTML_PATH") bytes)"

METADATA_JSON=$("${ROOT}/scripts/zenodo-metadata-json.sh" "${REPORT_ID}" "" "${RELEASE_TAG}")

echo "Creating new Zenodo deposition for ${REPORT_ID} (${RELEASE_TAG})..."

DEPOSITION=$(curl -fsS -X POST "${ZENODO_API}/deposit/depositions" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${METADATA_JSON}")

DEP_ID=$(echo "$DEPOSITION" | jq -r '.id')
BUCKET=$(echo "$DEPOSITION" | jq -r '.links.bucket // empty')
echo "Deposition ID: ${DEP_ID}"

if [ -n "$BUCKET" ] && [ "$BUCKET" != "null" ]; then
  for asset_path in "$PDF_PATH" "$HTML_PATH"; do
    asset=$(basename "$asset_path")
    curl -fsS -X PUT "${BUCKET}/${asset}" \
      -H "Authorization: Bearer ${TOKEN}" \
      --upload-file "$asset_path"
    echo "Uploaded ${asset}"
  done
else
  echo "ERROR: deposition bucket link missing" >&2
  exit 1
fi

echo ""
echo "Draft created: https://zenodo.org/deposit/${DEP_ID}"

if [ "$PUBLISH" = "true" ]; then
  echo "Publishing (ZENODO_PUBLISH=true)..."
  PUBLISHED=$(curl -fsS -X POST "${ZENODO_API}/deposit/depositions/${DEP_ID}/actions/publish" \
    -H "Authorization: Bearer ${TOKEN}")
  DOI=$(echo "$PUBLISHED" | jq -r '.doi // .metadata.doi // empty')
  RECORD_ID=$(echo "$PUBLISHED" | jq -r '.record // .id // empty')
  if [ -z "$DOI" ] || [ "$DOI" = "null" ]; then
    echo "ERROR: publish succeeded but DOI missing in response" >&2
    echo "$PUBLISHED" | jq . >&2 || true
    exit 1
  fi
  echo "Published DOI: ${DOI}"
  echo "Record ID: ${RECORD_ID}"
  echo "Zenodo: https://zenodo.org/records/${RECORD_ID}"
  echo "Run: ./scripts/update-doi.sh ${REPORT_ID} ${DOI} ${RECORD_ID}"
  if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "doi=${DOI}" >> "$GITHUB_OUTPUT"
    echo "record_id=${RECORD_ID}" >> "$GITHUB_OUTPUT"
  fi
else
  echo "Skipped publish (default). Set ZENODO_PUBLISH=true to auto-publish."
  echo "Then run: ./scripts/update-doi.sh ${REPORT_ID} <doi> ${DEP_ID}"
fi
