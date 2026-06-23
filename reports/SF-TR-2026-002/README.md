# SF-TR-2026-002 — Ferrum Field & Edge

Companion to [SF-TR-2026-001](../SF-TR-2026-001/) (server-centre Ferrum architecture).

## Render locally

```bash
cd reports/SF-TR-2026-002
../../scripts/render-mermaid-figures.sh SF-TR-2026-002   # optional; CI runs this
quarto render paper.qmd
```

Outputs: `_output/paper.html`, `_output/paper.pdf`

## Release

Follow [docs/workflow.md](../../docs/workflow.md): tag `SF-TR-2026-002-v1.0.0`, attach
rendered HTML/PDF, mint Zenodo DOI, update `catalog.yaml` and synapticfour.com catalogue.
