# Getting started

Render a draft in a new directory. Do not copy the template onto a report that is already published.

Prerequisites: [Quarto](https://quarto.org/docs/get-started/) 1.4 or newer, and Git. A TeX installation is required only for PDF. [Contributor guidance](contributing.md) names TinyTeX or a full TeX distribution.

Published reports in this clone:

- [SF-TR-2026-001](../reports/SF-TR-2026-001/) — [website page](https://synapticfour.com/en/publications/sf-tr-2026-001/)
- [SF-TR-2026-002](../reports/SF-TR-2026-002/) — [website page](https://synapticfour.com/en/publications/sf-tr-2026-002/)

## Render a new draft

Allocate the next identifier first. The rules are in [numbering.md](numbering.md). Register a `draft` row in [catalog.yaml](../publications-index/catalog.yaml) before treating the draft as part of the series.

```bash
cp -r templates/SF-TR-YYYY-NNN-template reports/SF-TR-YYYY-NNN
cd reports/SF-TR-YYYY-NNN
quarto render paper.qmd
```

Replace `YYYY-NNN` with the new identifier. `SF-TR-2026-001` and `SF-TR-2026-002` are already published. Copying the template onto either directory replaces that report's source.

You should see `reports/SF-TR-YYYY-NNN/_output/` (gitignored), including HTML. PDF needs the TeX installation named above. This repository does not pin a Quarto patch version. `quarto --version` should print 1.4 or newer.

## Render a published report without replacing its source

```bash
cd reports/SF-TR-2026-001
quarto render paper.qmd
```

`quarto render` writes `_output/`. It does not replace `paper.qmd`. The same command works in `reports/SF-TR-2026-002`. Optional figures for that report: `../../scripts/render-mermaid-figures.sh SF-TR-2026-002`, as its README already says.
