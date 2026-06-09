#!/usr/bin/env bash
# Backfill Zenodo DOI across catalogue, report source, and website mirror.
# Usage: ./scripts/update-doi.sh SF-TR-2026-001 10.5281/zenodo.1234567 [record-id]
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
WEBSITE_DATA="${ROOT}/../synapticfour-website/src/data/technicalReports.ts"

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

# Update catalog.yaml for matching report id
python3 << PYEOF
import yaml
from pathlib import Path

catalog_path = Path("${CATALOG}")
data = yaml.safe_load(catalog_path.read_text())
for report in data.get("reports", []):
    if report.get("id") == "${REPORT_ID}":
        report["doi"] = "${DOI}"
        if "${ZENODO_URL}":
            report["zenodo"] = "${ZENODO_URL}"
catalog_path.write_text(yaml.dump(data, sort_keys=False, allow_unicode=True))
print(f"Updated {catalog_path}")
PYEOF

if [ -f "$WEBSITE_DATA" ]; then
  python3 << PYEOF
import re
from pathlib import Path

path = Path("${WEBSITE_DATA}")
text = path.read_text()
block = re.search(r"('${REPORT_ID}': \\{[\\s\\S]*?\\n  \\})", text)
if not block:
    raise SystemExit("Report block not found in website data file")
section = block.group(1)
section = re.sub(r"doi: '[^']*'", f"doi: '${DOI}'", section)
if "${ZENODO_URL}":
    section = re.sub(r"zenodo: '[^']*'", f"zenodo: '${ZENODO_URL}'", section)
text = text[: block.start(1)] + section + text[block.end(1) :]
path.write_text(text)
print(f"Updated {path}")
PYEOF
else
  echo "Website data file not found (skip): $WEBSITE_DATA"
fi

echo "Done. Re-render the report and commit changes in technical-reports and synapticfour-website."
