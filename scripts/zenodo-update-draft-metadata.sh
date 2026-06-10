#!/usr/bin/env bash
# Patch metadata on an existing Zenodo draft (e.g. after files were uploaded without metadata).
#
# Usage:
#   export ZENODO_ACCESS_TOKEN=...
#   ./scripts/zenodo-update-draft-metadata.sh SF-TR-2026-001 DRAFT_ID [PARENT_RECORD_ID] [RELEASE_TAG]
set -euo pipefail

REPORT_ID="${1:?Report ID required}"
DRAFT_ID="${2:?Zenodo draft record id required}"
PARENT_RECORD_ID="${3:-20612210}"
RELEASE_TAG="${4:-}"

ZENODO_API="${ZENODO_API:-https://zenodo.org/api}"
TOKEN="${ZENODO_ACCESS_TOKEN:?Set ZENODO_ACCESS_TOKEN}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PAYLOAD=$("${ROOT}/scripts/zenodo-metadata-json.sh" "${REPORT_ID}" "${PARENT_RECORD_ID}" "${RELEASE_TAG}")

DRAFT_URL=""
for url in \
  "${ZENODO_API}/records/${DRAFT_ID}/draft" \
  "${ZENODO_API}/records/${DRAFT_ID}"; do
  HTTP=$(curl -sS -o /tmp/zenodo-draft-check.json -w '%{http_code}' \
    "$url" -H "Authorization: Bearer ${TOKEN}")
  if [ "$HTTP" -lt 400 ]; then
  DRAFT_URL="$url"
    break
  fi
  echo "GET ${url} → HTTP ${HTTP}" >&2
done

if [ -z "${DRAFT_URL}" ]; then
  echo "ERROR: Could not resolve draft ${DRAFT_ID}" >&2
  exit 1
fi

echo "Updating metadata on draft ${DRAFT_ID}..."
echo "${PAYLOAD}" | jq '.metadata | {title, publication_date, resource_type, creators: [.creators[]?.name]}'

META_HTTP=$(curl -sS -o /tmp/zenodo-meta-response.json -w '%{http_code}' -X PUT "${DRAFT_URL}" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${PAYLOAD}")

if [ "$META_HTTP" -ge 400 ]; then
  echo "ERROR: Zenodo metadata update returned HTTP ${META_HTTP}" >&2
  cat /tmp/zenodo-meta-response.json >&2 || true
  exit 1
fi

echo "Metadata updated: https://zenodo.org/deposit/${DRAFT_ID}"
cat /tmp/zenodo-meta-response.json | jq '{id, metadata: {title: .metadata.title, publication_date: .metadata.publication_date, resource_type: .metadata.resource_type}}' 2>/dev/null || true
