# Synaptic Four Technical Report Series

Permanent, citable, technically rigorous publications documenting Synaptic Four's software, infrastructure, and reference implementations in bioinformatics, federated data systems, FAIR data, genomics, multi-omics, GA4GH standards, and privacy-preserving research platforms.

This repository is the **canonical source** for all Synaptic Four Technical Reports (SF-TR). It is designed for long-term maintenance, version control, automated rendering, DOI archival via Zenodo, and eventual adaptation to conference and journal formats.

**Discovery:** Published reports are listed at [synapticfour.com/publications](https://synapticfour.com/publications). This repository holds source, build tooling, and contributor documentation.

## Quick Start

```bash
# Install Quarto: https://quarto.org/docs/get-started/
quarto --version

# Copy the template for a new report
cp -r templates/SF-TR-YYYY-NNN-template reports/SF-TR-2026-001

# Edit metadata and content in reports/SF-TR-2026-001/paper.qmd
quarto render reports/SF-TR-2026-001/paper.qmd

# Outputs appear in reports/SF-TR-2026-001/_output/
```

## Repository Layout

```
technical-reports/
├── README.md                          # This file
├── CITATION.cff                       # Repository-level citation metadata
├── _quarto.yml                        # Quarto project configuration
├── .github/workflows/                 # CI: render HTML and PDF
├── templates/
│   └── SF-TR-YYYY-NNN-template/       # Reusable report scaffold
├── reports/                           # Published and in-progress reports
│   └── SF-TR-YYYY-NNN/                # One directory per report
├── figures/                           # Shared figures (report-specific figures live in each report)
├── csl/                               # Citation Style Language files
├── publications-index/                # Machine-readable catalogue of all reports
└── docs/                              # Process, strategy, and contributor documentation
```

## Technical Report Identifier

Every report receives a permanent identifier:

```
SF-TR-YYYY-NNN
```

| Component | Meaning |
|-----------|---------|
| `SF-TR`   | Synaptic Four Technical Report |
| `YYYY`    | Year of initial publication |
| `NNN`     | Three-digit sequence within that year (`001`–`999`) |

Examples: `SF-TR-2026-001`, `SF-TR-2026-002`, `SF-TR-2027-001`

See [docs/numbering.md](docs/numbering.md) for allocation rules and versioning conventions.

## Documentation

| Document | Description |
|----------|-------------|
| [docs/workflow.md](docs/workflow.md) | End-to-end workflow: writing, releasing, DOI, website, versioning |
| [docs/publication-strategy.md](docs/publication-strategy.md) | Overall publication philosophy and goals |
| [docs/website-publishing.md](docs/website-publishing.md) | Canonical workflow for synapticfour.com integration |
| [docs/zenodo-integration.md](docs/zenodo-integration.md) | Zenodo DOI minting and GitHub integration |
| [docs/citation-guide.md](docs/citation-guide.md) | How to cite reports; BibTeX examples |
| [docs/publication-categories.md](docs/publication-categories.md) | Report type taxonomy and when to use each |
| [docs/future-reports.md](docs/future-reports.md) | Candidate topics (no fixed schedule) |
| [docs/journal-conference-roadmap.md](docs/journal-conference-roadmap.md) | How reports may evolve into formal publications |
| [docs/contributing.md](docs/contributing.md) | Contributor guidelines |
| [publications-index/README.md](publications-index/README.md) | Report catalogue and index format |

## Publication Workflow (Summary)

1. **Write** — Author in Quarto/Markdown under `reports/SF-TR-YYYY-NNN/`.
2. **Review** — Internal technical review; update `publications-index/`.
3. **Release** — Create a GitHub Release tagged `SF-TR-YYYY-NNN-vX.Y.Z`.
4. **Archive** — Zenodo mints a versioned DOI from the release (see [docs/zenodo-integration.md](docs/zenodo-integration.md)).
5. **Publish** — Add HTML/PDF and metadata to [synapticfour.com](https://synapticfour.com) publications hub.
6. **Maintain** — Issue revised versions with new release tags; prior DOI versions remain archived.

## Technology Stack

| Tool | Role |
|------|------|
| [Quarto](https://quarto.org/) | Authoring and rendering (HTML, PDF) |
| Markdown | Primary authoring format |
| BibTeX | Bibliography management |
| GitHub Actions | Automated rendering on push and release |
| GitHub Releases | Versioned distribution |
| [Zenodo](https://zenodo.org/) | Long-term DOI archival |

## Citation

To cite this publication series repository:

```bibtex
@misc{synapticfour_technical_reports,
  author       = {{Synaptic Four}},
  title        = {Synaptic Four Technical Report Series},
  year         = {2026},
  publisher    = {GitHub},
  howpublished = {\url{https://github.com/SynapticFour/technical-reports}},
  note         = {Technical report repository}
}
```

See [CITATION.cff](CITATION.cff) and [docs/citation-guide.md](docs/citation-guide.md) for per-report citation formats.

## License

Report content is licensed individually; see each report's `paper.qmd` front matter. Repository infrastructure defaults to [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) unless otherwise stated.

## Contact

Questions about the technical report series: [contact@synapticfour.com](mailto:contact@synapticfour.com)
