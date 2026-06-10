#!/usr/bin/env bash
# Build a Zenodo/InvenioRDM metadata JSON payload for a technical report draft.
# Reads report fields from paper.qmd and falls back to the latest published parent record.
#
# Usage:
#   ./scripts/zenodo-metadata-json.sh SF-TR-2026-001 [PARENT_RECORD_ID] [RELEASE_TAG]
# Prints: {"metadata":{...}}
set -euo pipefail

REPORT_ID="${1:?Report ID required}"
PARENT_RECORD_ID="${2:-}"
RELEASE_TAG="${3:-}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PAPER="${ROOT}/reports/${REPORT_ID}/paper.qmd"
CATALOG="${ROOT}/publications-index/catalog.yaml"

if [ ! -f "$PAPER" ]; then
  echo "ERROR: missing ${PAPER}" >&2
  exit 1
fi

read_yaml_scalar() {
  local key="$1"
  grep -m1 "^${key}:" "$PAPER" | sed -E 's/^[^:]*:[[:space:]]*"?([^"]*)"?/\1/'
}

TITLE=$(read_yaml_scalar title)
VERSION=$(read_yaml_scalar version)
PUB_DATE=$(read_yaml_scalar date)

if [ -f "$CATALOG" ]; then
  CATALOG_DATE=$(awk -v id="$REPORT_ID" '
    $0 ~ "id: " id { found=1 }
    found && /^    date:/ { gsub(/^    date: "|"$/, ""); print; exit }
  ' "$CATALOG")
  if [ -n "${CATALOG_DATE}" ]; then
    PUB_DATE="${CATALOG_DATE}"
  fi
fi

ABSTRACT=$(awk '
  /^abstract: \|/ { flag=1; next }
  flag && /^[a-zA-Z#@]/ && !/^  / { exit }
  flag { sub(/^  /, ""); print }
' "$PAPER" | sed '/^$/d')

KEYWORDS_JSON=$(awk '
  /^keywords:/ { flag=1; next }
  flag && /^[^ ]/ { exit }
  flag && /^  - / { gsub(/^  - /, ""); print }
' "$PAPER" | jq -R -s 'split("\n") | map(select(length > 0))')
if [ "${KEYWORDS_JSON}" = "[]" ] || [ -z "${KEYWORDS_JSON}" ]; then
  KEYWORDS_JSON='["GA4GH","genomics","Ferrum"]'
fi

NOTES="Synaptic Four Technical Report Series. ${REPORT_ID} version ${VERSION}."
if [ -n "${RELEASE_TAG}" ]; then
  NOTES="${NOTES} GitHub release: ${RELEASE_TAG}."
fi

ZENODO_API="${ZENODO_API:-https://zenodo.org/api}"
PARENT_META="{}"
if [ -n "${PARENT_RECORD_ID}" ]; then
  PARENT_META=$(curl -fsS "${ZENODO_API}/records/${PARENT_RECORD_ID}" | jq '.metadata')
fi

jq -n \
  --arg title "${TITLE} (${REPORT_ID})" \
  --arg pubdate "${PUB_DATE}" \
  --arg desc "${ABSTRACT}" \
  --arg notes "${NOTES}" \
  --arg version "v${VERSION}" \
  --arg version_plain "${VERSION}" \
  --arg publisher "Synaptic Four" \
  --arg report "${REPORT_ID}" \
  --argjson parent "${PARENT_META}" \
  --argjson paper_keywords "${KEYWORDS_JSON}" \
  '
  ($parent // {}) as $p
  | {
      metadata: (
        {
          title: $title,
          publication_date: $pubdate,
          description: $desc,
          version: $version_plain,
          publisher: $publisher,
          notes: ($notes + " Report version " + $version + "."),
          access_right: ($p.access_right // "open"),
          creators: [
            {
              person_or_org: {
                name: "Synaptic Four",
                type: "organizational"
              },
              affiliations: [{name: "Synaptic Four"}]
            }
          ],
          keywords: (
            ([$report, "technical report", "Synaptic Four Technical Report"]
             + $paper_keywords
             + (if ($p.keywords // null) then $p.keywords else [] end))
            | unique
          ),
          resource_type: {id: "publication-report"},
          license: (
            if ($p.license // null) then $p.license
            else {id: "cc-by-4.0"}
            end
          )
        }
        | del(.doi)
        | del(.relations)
      )
    }
  '
