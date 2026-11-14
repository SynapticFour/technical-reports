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
# 3. Copy template onto a new identifier. Do not use SF-TR-2026-001 or SF-TR-2026-002.
cp -r templates/SF-TR-YYYY-NNN-template reports/SF-TR-YYYY-NNN

# 4. Render
cd reports/SF-TR-YYYY-NNN
quarto render paper.qmd
```

The full steps are in [docs/GETTING-STARTED.md](../docs/GETTING-STARTED.md).

Outputs are written to `reports/SF-TR-YYYY-NNN/_output/` (gitignored).

## Published Reports

See [publications-index/catalog.yaml](../publications-index/catalog.yaml) for the authoritative list.

| ID | Title | Status | Version | Website |
|----|-------|--------|---------|---------|
| [SF-TR-2026-001](SF-TR-2026-001/) | Ferrum Architecture: A GA4GH-Native Genomics Platform | published | 1.0.3 | [English page](https://synapticfour.com/en/publications/sf-tr-2026-001/) |
| [SF-TR-2026-002](SF-TR-2026-002/) | Ferrum Field & Edge: Offline-First GA4GH Nodes | published | 1.0.0 | [English page](https://synapticfour.com/en/publications/sf-tr-2026-002/) |

German and French pages use the same path under `/de/` and `/fr/`. The catalogue field is `website` in [publications-index/catalog.yaml](../publications-index/catalog.yaml).
