#!/usr/bin/env bash
# Backfill Zenodo DOI across catalogue, report source, and website mirror.
# Usage:
#   ./scripts/update-doi.sh SF-TR-2026-001 10.5281/zenodo.1234567
#   ./scripts/update-doi.sh SF-TR-2026-001 10.5281/zenodo.1234567 1234567
# Third argument (numeric record id) is optional — adds the Zenodo record URL.
# Do not copy placeholder text; use the real DOI from Zenodo after you publish the deposit.
set -euo pipefail

REPORT_ID="${1:?Report ID required, e.g. SF-TR-2026-001}"
DOI="${2:?DOI required, e.g. 10.5281/zenodo.1234567}"
RECORD_ID="${3:-}"

ZENODO_URL=""
if [ -n "$RECORD_ID" ]; then
  ZENODO_URL="https://zenodo.org/records/${RECORD_ID}"
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPORT_DIR="${ROOT}/reports/${REPORT_ID}"
CATALOG="${ROOT}/publications-index/catalog.yaml"
WEBSITE_CATALOG="${ROOT}/../synapticfour-website/src/data/publicationsCatalog.ts"
WEBSITE_LEGACY="${ROOT}/../synapticfour-website/src/data/technicalReports.ts"

if [ ! -d "$REPORT_DIR" ]; then
  echo "Report directory not found: $REPORT_DIR" >&2
  exit 1
fi

# Update paper.qmd front matter
python3 << PYEOF
import re
from pathlib import Path

paper = Path("${REPORT_DIR}") / "paper.qmd"
text = paper.read_text()
text = re.sub(r'^doi:.*$', f'doi: "${DOI}"', text, flags=re.M)
if "${ZENODO_URL}":
    text = re.sub(r'^zenodo:.*$', f'zenodo: "${ZENODO_URL}"', text, flags=re.M)
paper.write_text(text)
print(f"Updated {paper}")
PYEOF

# Update catalog.yaml for matching report id (sed — no PyYAML dependency)
if grep -q "id: ${REPORT_ID}" "${CATALOG}"; then
  python3 << PYEOF
import re
from pathlib import Path

catalog_path = Path("${CATALOG}")
text = catalog_path.read_text()
block = re.search(
    rf"(  - id: ${REPORT_ID}\n(?:    .*\n)*?)(    doi: ).*(\n    zenodo: ).*",
    text,
)
if not block:
    raise SystemExit(f"Report block not found in {catalog_path}")
zenodo_val = "${ZENODO_URL}" if "${ZENODO_URL}" else ""
replacement = (
    block.group(1)
    + block.group(2)
    + '"${DOI}"'
    + block.group(3)
    + (f'"{zenodo_val}"' if zenodo_val else '""')
)
text = text[: block.start()] + replacement + text[block.end() :]
catalog_path.write_text(text)
print(f"Updated {catalog_path}")
PYEOF
else
  echo "Report not found in catalog (skip): ${CATALOG}" >&2
fi

update_website_doi() {
  local path="$1"
  [ -f "$path" ] || return 0
  python3 << PYEOF
import re
from pathlib import Path

path = Path("${path}")
text = path.read_text()
# publicationsCatalog.ts: id: 'SF-TR-...' block; technicalReports.ts: 'SF-TR-...': { block
patterns = [
    rf"id: '${REPORT_ID}'[\\s\\S]*?\\n  \\}}",
    rf"'${REPORT_ID}': \\{{[\\s\\S]*?\\n  \\}}",
]
block = None
for pat in patterns:
    m = re.search(pat, text)
    if m:
        block = m
        break
if not block:
    raise SystemExit(f"Report block not found in {path}")
section = block.group(0)
section = re.sub(r"doi: '[^']*'", f"doi: '${DOI}'", section)
if "${ZENODO_URL}":
    section = re.sub(r"zenodo: '[^']*'", f"zenodo: '${ZENODO_URL}'", section)
text = text[: block.start()] + section + text[block.end() :]
path.write_text(text)
print(f"Updated {path}")
PYEOF
}

update_website_doi "$WEBSITE_CATALOG"
update_website_doi "$WEBSITE_LEGACY"

echo "Done. Re-render the report and commit changes in technical-reports and synapticfour-website."
