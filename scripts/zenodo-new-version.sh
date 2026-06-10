#!/usr/bin/env bash
# Create a Zenodo *draft* for the next version of an existing record and upload
# release artefacts. Does not publish unless ZENODO_PUBLISH=true.
#
# Prerequisites:
#   export ZENODO_ACCESS_TOKEN=...   # deposit:write, deposit:actions
#
# Usage:
#   ./scripts/zenodo-new-version.sh SF-TR-2026-001 SF-TR-2026-001-v1.0.2 20612210
#
# Arguments:
#   1  Report ID (SF-TR-2026-001)
#   2  GitHub release tag (must exist with SF-TR-*.pdf and .html assets)
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

echo "Preparing Zenodo draft for ${REPORT_ID} v${VERSION} from GitHub release ${RELEASE_TAG}..."

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI required to download release assets" >&2
  exit 1
fi

if ! gh release view "${RELEASE_TAG}" --repo "${REPO}" >/dev/null 2>&1; then
  echo "ERROR: GitHub release '${RELEASE_TAG}' not found on ${REPO}." >&2
  echo "Create the release with ${REPORT_ID}.pdf and ${REPORT_ID}.html assets first, then re-run." >&2
  echo "Available releases:" >&2
  gh release list --repo "${REPO}" --limit 5 >&2 || true
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
  echo "ERROR: Could not download ${asset} from release ${RELEASE_TAG}" >&2
  exit 1
}

PDF_PATH=$(download_release_asset "${REPORT_ID}.pdf")
HTML_PATH=$(download_release_asset "${REPORT_ID}.html")
echo "Downloaded release assets:"
echo "  ${PDF_PATH} ($(wc -c < "$PDF_PATH") bytes)"
echo "  ${HTML_PATH} ($(wc -c < "$HTML_PATH") bytes)"

echo "Creating or reusing Zenodo version draft from record ${ZENODO_RECORD_ID}..."

NEW_VERSION=""
VERSION_HTTP=$(curl -sS -o /tmp/zenodo-version.json -w '%{http_code}' -X POST \
  "${ZENODO_API}/records/${ZENODO_RECORD_ID}/versions" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json")
if [ "$VERSION_HTTP" -lt 400 ]; then
  NEW_VERSION=$(cat /tmp/zenodo-version.json)
else
  echo "POST /versions returned HTTP ${VERSION_HTTP} (often: an open draft already exists)." >&2
  cat /tmp/zenodo-version.json >&2 2>/dev/null || true
  if [ -n "${ZENODO_DRAFT_ID:-}" ]; then
    echo "Reusing ZENODO_DRAFT_ID=${ZENODO_DRAFT_ID}" >&2
    NEW_VERSION=$(curl -fsS "${ZENODO_API}/records/${ZENODO_DRAFT_ID}/draft" \
      -H "Authorization: Bearer ${TOKEN}")
  else
    PUBLISHED=$(curl -sS "${ZENODO_API}/records/${ZENODO_RECORD_ID}" \
      -H "Authorization: Bearer ${TOKEN}" 2>/dev/null || echo '{}')
    DRAFT_LINK=$(echo "$PUBLISHED" | jq -r '.links.latest_draft // empty')
    if [ -n "$DRAFT_LINK" ] && [ "$DRAFT_LINK" != "null" ]; then
      echo "Reusing latest_draft from published record." >&2
      NEW_VERSION=$(curl -fsS "$DRAFT_LINK" -H "Authorization: Bearer ${TOKEN}")
    fi
  fi
fi

DRAFT_ID=$(echo "$NEW_VERSION" | jq -r '.id // empty')
DRAFT_URL=$(echo "$NEW_VERSION" | jq -r '.links.self // empty')
FILES_URL=$(echo "$NEW_VERSION" | jq -r '.links.files // empty')
if [ -z "$FILES_URL" ] || [ "$FILES_URL" = "null" ]; then
  FILES_URL="${DRAFT_URL%/}/files"
fi

if [ -z "$DRAFT_ID" ] || [ "$DRAFT_ID" = "null" ]; then
  echo "ERROR: No Zenodo draft available." >&2
  echo "Open https://zenodo.org/me/uploads — delete any stale SF-TR draft, or set ZENODO_DRAFT_ID." >&2
  echo "Ensure ZENODO_ACCESS_TOKEN belongs to the same Zenodo account you use in the browser." >&2
  exit 1
fi

echo "Draft API: ${DRAFT_URL}"
echo "Files API: ${FILES_URL}"
echo "Draft record id: ${DRAFT_ID}"

for asset_path in "$PDF_PATH" "$HTML_PATH"; do
    asset=$(basename "$asset_path")
    FILES_LIST=$(curl -sS "$FILES_URL" -H "Authorization: Bearer ${TOKEN}" 2>/dev/null || echo '{"entries":[]}')
    EXISTING_URL=$(echo "$FILES_LIST" | jq -r --arg fn "$asset" \
      '.entries[]? | select(.key==$fn) | .links.self // empty' | head -1)
    if [ -n "$EXISTING_URL" ] && [ "$EXISTING_URL" != "null" ]; then
      echo "Removing existing draft file: ${asset}"
      curl -fsS -X DELETE "$EXISTING_URL" -H "Authorization: Bearer ${TOKEN}" || true
    fi
    HTTP=$(curl -sS -o /tmp/zenodo-file-post.json -w '%{http_code}' -X POST "${FILES_URL}" \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "Content-Type: application/json" \
      -d "$(jq -n --arg fn "$asset" '[{key: $fn}]')")
    if [ "$HTTP" -ge 400 ]; then
      echo "ERROR: Zenodo file register failed HTTP ${HTTP} for ${asset}" >&2
      cat /tmp/zenodo-file-post.json >&2 || true
      exit 1
    fi
    FILES_LIST=$(curl -sS "$FILES_URL" -H "Authorization: Bearer ${TOKEN}")
    UPLOAD_URL=$(echo "$FILES_LIST" | jq -r --arg fn "$asset" \
      '.entries[] | select(.key==$fn) | .links.content // .links.self')
    if [ -z "$UPLOAD_URL" ] || [ "$UPLOAD_URL" = "null" ]; then
      echo "ERROR: file upload URL not found for ${asset}" >&2
      echo "$FILES_LIST" | jq . >&2 || true
      exit 1
    fi
    HTTP=$(curl -sS -o /tmp/zenodo-upload-response.json -w '%{http_code}' -X PUT "$UPLOAD_URL" \
      -H "Authorization: Bearer ${TOKEN}" \
      --upload-file "$asset_path")
    if [ "$HTTP" -ge 400 ]; then
      echo "ERROR: Zenodo file upload failed HTTP ${HTTP} for ${asset}" >&2
      cat /tmp/zenodo-upload-response.json >&2 || true
      exit 1
    fi
    echo "Uploaded ${asset}"
  done
  META_HTTP=$(curl -sS -o /tmp/zenodo-meta-response.json -w '%{http_code}' -X PUT "${DRAFT_URL}" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$(jq -n \
      --arg v "v${VERSION}" \
      --arg title "${TITLE} (${REPORT_ID})" \
      --arg notes "Synaptic Four Technical Report Series. GitHub release: ${RELEASE_TAG}" \
      '{metadata: {title: $title, version: $v, notes: $notes}}')")
  if [ "$META_HTTP" -ge 400 ]; then
    echo "WARNING: Zenodo metadata update returned HTTP ${META_HTTP} (files are uploaded; edit metadata in UI)." >&2
    cat /tmp/zenodo-meta-response.json >&2 || true
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
