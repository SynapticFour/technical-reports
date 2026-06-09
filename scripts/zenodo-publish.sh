#!/usr/bin/env bash
# Create or update a Zenodo deposition via API (alternative to GitHub UI toggle).
# Requires a personal access token: https://zenodo.org/account/settings/applications/tokens/new/
# Scopes: deposit:write, deposit:actions
#
# Usage:
#   export ZENODO_ACCESS_TOKEN=...
#   ./scripts/zenodo-publish.sh SF-TR-2026-001 SF-TR-2026-001-v1.0.0
#
# Note: GitHub–Zenodo webhook (automatic release ingestion) still requires one UI step:
#   https://zenodo.org/account/settings/github/ → enable SynapticFour/technical-reports
set -euo pipefail

REPORT_ID="${1:?Report ID required}"
RELEASE_TAG="${2:?Release tag required}"
ZENODO_API="${ZENODO_API:-https://zenodo.org/api}"
TOKEN="${ZENODO_ACCESS_TOKEN:?Set ZENODO_ACCESS_TOKEN}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PAPER="${ROOT}/reports/${REPORT_ID}/paper.qmd"
TITLE=$(grep -m1 '^title:' "$PAPER" | sed 's/^title: *"\(.*\)"/\1/')
ABSTRACT=$(awk '/^abstract: \|/{flag=1;next} /^[a-z]/ && !/^  /{if(flag) exit} flag{print}' "$PAPER" | head -20)

echo "Creating Zenodo deposition for ${REPORT_ID} (${RELEASE_TAG})..."

DEPOSITION=$(curl -fsS -X POST "${ZENODO_API}/deposit/depositions" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg title "${TITLE} (${REPORT_ID})" \
    --arg desc "$ABSTRACT" \
    --arg tag "$REPORT_ID" \
    '{
      metadata: {
        title: $title,
        upload_type: "publication",
        publication_type: "report",
        description: $desc,
        creators: [{name: "Synaptic Four", affiliation: "Synaptic Four"}],
        keywords: [$tag, "technical report", "GA4GH", "bioinformatics"],
        license: "cc-by-4.0",
        notes: "Synaptic Four Technical Report Series. GitHub release: '"${RELEASE_TAG}"'"
      }
    }')")

BUCKET=$(echo "$DEPOSITION" | jq -r '.links.bucket')
DEP_ID=$(echo "$DEPOSITION" | jq -r '.id')
echo "Deposition ID: ${DEP_ID}"

REPO="${GITHUB_REPO:-SynapticFour/technical-reports}"
for asset in "${REPORT_ID}.pdf" "${REPORT_ID}.html"; do
  TMP="/tmp/${asset}"
  if command -v gh >/dev/null 2>&1 && gh release download "${RELEASE_TAG}" \
    --repo "${REPO}" --pattern "${asset}" --dir /tmp --clobber 2>/dev/null; then
    :
  elif curl -fsSL -o "$TMP" \
    "https://github.com/${REPO}/releases/download/${RELEASE_TAG}/${asset}"; then
    :
  else
    echo "Skip ${asset} (not found on release — private repo needs gh auth)"
    continue
  fi
  if [ -f "$TMP" ]; then
    curl -fsS -X PUT "${BUCKET}/${asset}" \
      -H "Authorization: Bearer ${TOKEN}" \
      --upload-file "$TMP"
    echo "Uploaded ${asset}"
    rm -f "$TMP"
  fi
done

echo ""
echo "Draft created: https://zenodo.org/deposit/${DEP_ID}"
echo "Publish manually in Zenodo UI, or:"
echo "  curl -X POST ${ZENODO_API}/deposit/depositions/${DEP_ID}/actions/publish -H \"Authorization: Bearer \$ZENODO_ACCESS_TOKEN\""
echo "Then run: ./scripts/update-doi.sh ${REPORT_ID} <doi> ${DEP_ID}"
