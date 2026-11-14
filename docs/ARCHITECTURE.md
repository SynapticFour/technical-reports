# How this series is arranged

This page is the shape of the report repository: directories, identifiers, and the path from a draft to a website page.

## Layout

```
technical-reports/
├── README.md                          # Entry page
├── CITATION.cff                       # Series citation metadata
├── _quarto.yml                        # Quarto project configuration
├── .github/workflows/                 # CI: render HTML and PDF, validate the catalogue
├── templates/
│   └── SF-TR-YYYY-NNN-template/       # Reusable report scaffold
├── reports/                           # Published and in-progress reports
│   └── SF-TR-YYYY-NNN/                # One directory per report
├── figures/                           # Shared figures (report-specific figures live in each report)
├── csl/                               # Citation Style Language files
├── publications-index/                # Machine-readable catalogue of all reports
└── docs/                              # Process, strategy, and contributor documentation
```

## Identifier

Every report receives a permanent identifier `SF-TR-YYYY-NNN`. `SF-TR` is the series, `YYYY` is the year of initial publication, and `NNN` is the three-digit sequence in that year. A report's own version lives in that report's front matter and is not this identifier. Allocation and release tags are in [numbering.md](numbering.md).

## From draft to a website page

1. **Write** — Author in Quarto under `reports/SF-TR-YYYY-NNN/`. Copy the template only onto a new identifier. [Getting started](GETTING-STARTED.md).
2. **Review** — Internal technical review; update `publications-index/`. [Workflow](workflow.md).
3. **Release** — Create a GitHub Release tagged `SF-TR-YYYY-NNN-vX.Y.Z`.
4. **Archive** — Zenodo mints a versioned DOI from the release. [Zenodo](zenodo-integration.md).
5. **Publish** — The website page for each published report is linked from the catalogue and from the report directory.
6. **Maintain** — A revised version gets a new release tag. Prior DOI versions stay archived.

## Tools

| Tool | Role |
|------|------|
| [Quarto](https://quarto.org/) | Authoring and rendering (HTML, PDF). 1.4 or newer. |
| Markdown | Primary authoring format |
| BibTeX | Bibliography management |
| GitHub Actions | Automated rendering on push and release |
| GitHub Releases | Versioned distribution |
| [Zenodo](https://zenodo.org/) | Long-term DOI archival |
