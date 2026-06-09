#!/usr/bin/env bash
# Create a Zenodo *draft* for the next version of an existing record and upload
# release artefacts. Does not publish unless ZENODO_PUBLISH=true.
#
# Prerequisites:
#   export ZENODO_ACCESS_TOKEN=...   # deposit:write, deposit:actions
#
# Usage:
#   ./scripts/zenodo-new-version.sh SF-TR-2026-001 SF-TR-2026-001-v1.0.1 20612210
#
# Arguments:
#   1  Report ID (SF-TR-2026-001)
#   2  GitHub release tag
#   3  Latest Zenodo *version* record id (from URL /records/20612210 → 20612210)
set -euo pipefail

REPORT_ID="${1:?Report ID required}"
RELEASE_TAG="${2:?Release tag required}"
ZENODO_RECORD_ID="${3:?Zenodo record id required (latest published version)}"

ZENODO_API="${ZENODO_API:-https://zenodo.org/api}"
TOKEN="${ZENODO_ACCESS_TOKEN:?Set ZENODO_ACCESS_TOKEN}"
PUBLISH="${ZENODO_PUBLISH:-false}"
REPO="${GITHUB_REPO:-SynapticFour/technical-reports}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PAPER="${ROOT}/reports/${REPORT_ID}/paper.qmd"
VERSION=$(grep -m1 '^version:' "$PAPER" | sed 's/^version: *"\(.*\)"/\1/')
TITLE=$(grep -m1 '^title:' "$PAPER" | sed 's/^title: *"\(.*\)"/\1/')

echo "Creating Zenodo draft for ${REPORT_ID} ${VERSION} from release ${RELEASE_TAG}..."
echo "Base record id: ${ZENODO_RECORD_ID}"

# InvenioRDM (current Zenodo): POST /api/records/{id}/versions
NEW_VERSION=$(curl -fsS -X POST "${ZENODO_API}/records/${ZENODO_RECORD_ID}/versions" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json")

DRAFT_ID=$(echo "$NEW_VERSION" | jq -r '.id')
DRAFT_URL=$(echo "$NEW_VERSION" | jq -r '.links.self // empty')
FILES_URL=$(echo "$NEW_VERSION" | jq -r '.links.files // empty')

if [ -z "$DRAFT_ID" ] || [ "$DRAFT_ID" = "null" ]; then
  echo "records/versions failed; trying legacy deposit newversion..." >&2
  LEGACY=$(curl -fsS -X POST "${ZENODO_API}/deposit/depositions/${ZENODO_RECORD_ID}/actions/newversion" \
    -H "Authorization: Bearer ${TOKEN}")
  DRAFT_URL=$(echo "$LEGACY" | jq -r '.links.latest_draft // empty')
  DRAFT_ID="${DRAFT_URL##*/}"
  if [ -z "$DRAFT_ID" ] || [ "$DRAFT_ID" = "null" ]; then
    echo "Could not create new Zenodo version draft." >&2
    echo "$LEGACY" | jq . >&2 || true
    exit 1
  fi
  # Legacy upload path
  BUCKET=$(curl -fsS "${DRAFT_URL}" -H "Authorization: Bearer ${TOKEN}" | jq -r '.links.bucket')
  for asset in "${REPORT_ID}.pdf" "${REPORT_ID}.html"; do
    TMP="/tmp/${asset}"
    gh release download "${RELEASE_TAG}" --repo "${REPO}" --pattern "${asset}" --dir /tmp --clobber
    curl -fsS -X PUT "${BUCKET}/${asset}" \
      -H "Authorization: Bearer ${TOKEN}" \
      --upload-file "$TMP"
    echo "Uploaded ${asset}"
    rm -f "$TMP"
  done
  curl -fsS -X PUT "${DRAFT_URL}" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$(jq -n \
      --arg v "v${VERSION}" \
      --arg notes "Synaptic Four Technical Report Series. GitHub release: ${RELEASE_TAG}" \
      '{metadata: {version: $v, notes: $notes}}')"
else
  echo "Draft record id: ${DRAFT_ID}"
  for asset in "${REPORT_ID}.pdf" "${REPORT_ID}.html"; do
    TMP="/tmp/${asset}"
    gh release download "${RELEASE_TAG}" --repo "${REPO}" --pattern "${asset}" --dir /tmp --clobber
    curl -fsS -X POST "${FILES_URL}" \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "Content-Type: application/json" \
      -d "$(jq -n --arg fn "$asset" '{key: $fn}')"
    UPLOAD_URL=$(curl -fsS "${ZENODO_API}/records/${DRAFT_ID}/files" \
      -H "Authorization: Bearer ${TOKEN}" | jq -r --arg fn "$asset" '.entries[] | select(.key==$fn) | .links.self')
    curl -fsS -X PUT "$UPLOAD_URL/content" \
      -H "Authorization: Bearer ${TOKEN}" \
      --upload-file "$TMP"
    echo "Uploaded ${asset}"
    rm -f "$TMP"
  done
  curl -fsS -X PUT "${DRAFT_URL}" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$(jq -n \
      --arg v "v${VERSION}" \
      --arg title "${TITLE} (${REPORT_ID})" \
      --arg notes "Synaptic Four Technical Report Series. GitHub release: ${RELEASE_TAG}" \
      '{metadata: {title: $title, version: $v, notes: $notes}}')"
fi

echo ""
echo "Zenodo draft ready: https://zenodo.org/deposit/${DRAFT_ID}"
echo "Review in Zenodo UI before publishing a new version DOI."

if [ "$PUBLISH" = "true" ]; then
  echo "Publishing (ZENODO_PUBLISH=true)..."
  curl -fsS -X POST "${ZENODO_API}/records/${DRAFT_ID}/draft/actions/publish" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{}' || \
  curl -fsS -X POST "${ZENODO_API}/deposit/depositions/${DRAFT_ID}/actions/publish" \
    -H "Authorization: Bearer ${TOKEN}"
  echo "Published. Fetch the new version DOI from Zenodo and run update-doi.sh."
else
  echo "Skipped publish (default). Set ZENODO_PUBLISH=true to auto-publish."
fi
