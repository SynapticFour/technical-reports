#!/usr/bin/env bash
# Finalize pending file uploads on a Zenodo draft (POST .../commit per file).
#
# InvenioRDM leaves API-uploaded files in status "pending" until committed.
# Until then the Zenodo UI shows "Progress Pending" and blocks publish.
#
# Usage:
#   export ZENODO_ACCESS_TOKEN=...
#   ./scripts/zenodo-commit-draft-files.sh DRAFT_ID
set -euo pipefail

DRAFT_ID="${1:?Zenodo draft record id required}"
ZENODO_API="${ZENODO_API:-https://zenodo.org/api}"
TOKEN="${ZENODO_ACCESS_TOKEN:?Set ZENODO_ACCESS_TOKEN}"
BASE="${ZENODO_API%/api}"

resolve_url() {
  local url="$1"
  if [[ "$url" == http* ]]; then
    echo "$url"
  elif [[ "$url" == /* ]]; then
    echo "${BASE}${url}"
  else
    echo "${ZENODO_API}/${url}"
  fi
}

FILES_URL="${ZENODO_API}/records/${DRAFT_ID}/draft/files"
FILES_LIST=$(curl -fsS "$FILES_URL" -H "Authorization: Bearer ${TOKEN}")

echo "$FILES_LIST" | jq -r '.entries[]? | "\(.key)\t\(.status)\t\(.links.commit // "")"' | while IFS=$'\t' read -r key status commit_link; do
  [ -n "$key" ] || continue
  echo "File: ${key} (status=${status})"
  if [ "$status" = "completed" ]; then
    echo "  already completed"
    continue
  fi
  if [ -z "$commit_link" ] || [ "$commit_link" = "null" ]; then
    echo "  ERROR: no commit link for ${key}" >&2
    exit 1
  fi
  COMMIT_URL=$(resolve_url "$commit_link")
  HTTP=$(curl -sS -o /tmp/zenodo-commit.json -w '%{http_code}' -X POST "$COMMIT_URL" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{}')
  if [ "$HTTP" -ge 400 ]; then
    echo "  ERROR: commit failed HTTP ${HTTP}" >&2
    cat /tmp/zenodo-commit.json >&2 || true
    exit 1
  fi
  NEW_STATUS=$(jq -r '.status // "unknown"' /tmp/zenodo-commit.json 2>/dev/null || echo "committed")
  echo "  committed (status=${NEW_STATUS})"
done

echo ""
echo "Draft files: https://zenodo.org/deposit/${DRAFT_ID}"
