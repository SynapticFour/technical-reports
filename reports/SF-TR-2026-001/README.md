# SF-TR Report Template

Copy this directory to `reports/SF-TR-YYYY-NNN/` when starting a new technical report.

```bash
cp -r templates/SF-TR-YYYY-NNN-template reports/SF-TR-2026-001
```

## Checklist

- [ ] Replace `YYYY` and `NNN` in directory name and all front matter fields
- [ ] Update `title`, `subtitle`, `author`, `abstract`, and `keywords`
- [ ] Set `report-category` (see [docs/publication-categories.md](../../docs/publication-categories.md))
- [ ] Register the report in [publications-index/catalog.yaml](../../publications-index/catalog.yaml)
- [ ] Add report-specific figures to a local `figures/` subdirectory
- [ ] Populate `references.bib`
- [ ] Remove or complete placeholder sections
- [ ] Render locally: `quarto render paper.qmd`
- [ ] Follow [docs/workflow.md](../../docs/workflow.md) for release and DOI

## Local Figures

Place report-specific figures in `reports/SF-TR-YYYY-NNN/figures/`. Reference them in `paper.qmd`:

```markdown
![Component diagram](figures/architecture.png){#fig-arch width=80%}
```

Shared figures used across multiple reports may live in the repository-level `figures/` directory.
