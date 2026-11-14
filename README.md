# Synaptic Four Technical Report Series

This repository is the source of the SF-TR series: citable reports on how Synaptic Four software is built, so a later reader can check a report and cite it.

For someone reading a published report, and for someone writing the next one.

**Status: No public status is recorded.** A report's own version lives in that report's front matter. The claims registry has no stage for this series.

Published reports are listed at [https://synapticfour.com/en/publications/](https://synapticfour.com/en/publications/).

## What is in this repository

- [publications-index/catalog.yaml](publications-index/catalog.yaml) — the catalogue
- [templates/SF-TR-YYYY-NNN-template/](templates/SF-TR-YYYY-NNN-template/) — the scaffold for a new report
- [reports/SF-TR-2026-001](reports/SF-TR-2026-001/) — Ferrum Architecture, version 1.0.3. Website: [https://synapticfour.com/en/publications/sf-tr-2026-001/](https://synapticfour.com/en/publications/sf-tr-2026-001/)
- [reports/SF-TR-2026-002](reports/SF-TR-2026-002/) — Ferrum Field & Edge, version 1.0.0. Website: [https://synapticfour.com/en/publications/sf-tr-2026-002/](https://synapticfour.com/en/publications/sf-tr-2026-002/)

## What it does

- Keeps each report's Quarto source, citation file, and catalogue row together.
- Renders HTML and PDF with Quarto. The rendered files go to `_output/`, which is gitignored.
- Publishes a version by a GitHub release tag and a Zenodo DOI. The identifier `SF-TR-YYYY-NNN` stays. The version changes.

## Limits

- The internal technical and editorial review is not a journal peer review. [docs/journal-conference-roadmap.md](docs/journal-conference-roadmap.md) says an SF-TR is usually acceptable as a non-peer-reviewed preprint.
- A report does not certify the software it describes. SF-TR-2026-001 says a HelixTest result is a technical conformance signal, not official GA4GH certification.
- [docs/future-reports.md](docs/future-reports.md) lists candidate topics. It is not a schedule.
- Copying the template onto `reports/SF-TR-2026-001` or `reports/SF-TR-2026-002` replaces a published source.
- GitHub may report this repository's licence as not asserted. The file in the tree is CC BY 4.0. Individual reports may name a different licence in their front matter.

## Render a draft

Prerequisites: [Quarto](https://quarto.org/docs/get-started/) 1.4 or newer. PDF also needs a TeX installation, as [docs/contributing.md](docs/contributing.md) names it.

```bash
cp -r templates/SF-TR-YYYY-NNN-template reports/SF-TR-YYYY-NNN
cd reports/SF-TR-YYYY-NNN
quarto render paper.qmd
```

Replace `YYYY-NNN` with a new identifier. You should see `_output/` in that new directory. The steps, and how to re-render a published report without replacing `paper.qmd`, are in [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md).

## Documentation

### Tutorial

- [Getting started](docs/GETTING-STARTED.md)

### How-to guides

- [Workflow](docs/workflow.md) — writing, release, DOI, website, versioning
- [Website publishing](docs/website-publishing.md)
- [Zenodo](docs/zenodo-integration.md)
- [Contributing](docs/contributing.md)

### Reference

- [Numbering](docs/numbering.md)
- [Citation guide](docs/citation-guide.md)
- [Categories](docs/publication-categories.md)
- [For evaluators](docs/FOR-EVALUATORS.md)
- Catalogue: [publications-index/README.md](publications-index/README.md)

### Explanation

- [How the series is arranged](docs/ARCHITECTURE.md)
- [Publication strategy](docs/publication-strategy.md)
- [Candidate topics](docs/future-reports.md)
- [Journal and conference roadmap](docs/journal-conference-roadmap.md)

The full index is [docs/README.md](docs/README.md).

## Licence

Report content is licensed in each report's front matter. Repository infrastructure, templates, and documentation are Creative Commons Attribution 4.0 International: share and adapt them, with attribution. The file is [LICENSE](LICENSE).

## Cite

Use [CITATION.cff](CITATION.cff) for the series. Prefer that file over a hand-copied line. Each report has its own citation file at `reports/SF-TR-YYYY-NNN/CITATION.cff`.

## Website

- Publications: [https://synapticfour.com/en/publications/](https://synapticfour.com/en/publications/)
- Technical profile: [https://synapticfour.com/en/technical/code/](https://synapticfour.com/en/technical/code/)

The same pages exist in German (`/de/publications/`, `/de/technik/code/`) and in French (`/fr/publications/`, `/fr/technique/code/`).

The map of repositories: [profile/README.md](https://github.com/SynapticFour/.github/blob/main/profile/README.md).

Contact: [contact@synapticfour.com](mailto:contact@synapticfour.com)
