# Reports

Published and in-progress Synaptic Four Technical Reports.

Each report lives in its own directory:

```
reports/SF-TR-YYYY-NNN/
  paper.qmd          # Main document
  references.bib     # Bibliography
  figures/           # Report-specific figures (optional)
  CITATION.cff       # Per-report citation metadata (optional)
```

## Creating a New Report

```bash
# 1. Allocate number — see docs/numbering.md
# 2. Register in publications-index/catalog.yaml
# 3. Copy template
cp -r templates/SF-TR-YYYY-NNN-template reports/SF-TR-2026-001

# 4. Render
cd reports/SF-TR-2026-001
quarto render paper.qmd
```

Outputs are written to `reports/SF-TR-YYYY-NNN/_output/` (gitignored).

## Published Reports

See [publications-index/catalog.yaml](../publications-index/catalog.yaml) for the authoritative list.

| ID | Title | Status |
|----|-------|--------|
| — | No reports published yet | — |
