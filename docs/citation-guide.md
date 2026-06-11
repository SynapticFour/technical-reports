# Citation Guide

How to cite Synaptic Four Technical Reports and this repository.

## Citing an Individual Report

Always prefer the **version DOI** when available. Include the SF-TR identifier for disambiguation.

### BibTeX (recommended)

```bibtex
@techreport{synapticfour2026ferrum,
  author       = {{Synaptic Four}},
  title        = {Ferrum Architecture: A {GA4GH}-Native Genomics Platform},
  institution  = {Synaptic Four},
  number       = {SF-TR-2026-001},
  year         = {2026},
  version      = {1.0.3},
  type         = {Technical Report},
  doi          = {10.5281/zenodo.20628103},
  url          = {https://synapticfour.com/publications/sf-tr-2026-001},
  note         = {Synaptic Four Technical Report Series}
}
```

### APA Style

> Synaptic Four. (2026). *Ferrum Architecture: A GA4GH-Native Genomics Platform* (Synaptic Four Technical Report SF-TR-2026-001, Version 1.0.3). https://doi.org/10.5281/zenodo.20628103

### Chicago (Author-Date)

> Synaptic Four. 2026. "Ferrum Architecture: A GA4GH-Native Genomics Platform." Synaptic Four Technical Report SF-TR-2026-001, Version 1.0.3. https://doi.org/10.5281/zenodo.20628103.

### Plain text

```
Synaptic Four. Ferrum Architecture: A GA4GH-Native Genomics Platform.
Synaptic Four Technical Report SF-TR-2026-001, Version 1.0.3 (2026).
https://doi.org/10.5281/zenodo.20628103
```

## Citing the Report Series (Repository)

```bibtex
@misc{synapticfour_tr_series,
  author       = {{Synaptic Four}},
  title        = {Synaptic Four Technical Report Series},
  year         = {2026},
  publisher    = {GitHub},
  howpublished = {\url{https://github.com/SynapticFour/technical-reports}},
  note         = {Open technical report repository}
}
```

The repository root [CITATION.cff](../CITATION.cff) provides machine-readable metadata for GitHub's "Cite this repository" feature.

## Citing Without a DOI (Draft or Pre-release)

For reports not yet archived on Zenodo, cite the GitHub commit or release tag:

```bibtex
@misc{synapticfour2026ferrum_draft,
  author       = {{Synaptic Four}},
  title        = {Ferrum Architecture: A {GA4GH}-Native Genomics Platform},
  year         = {2026},
  note         = {Synaptic Four Technical Report SF-TR-2026-001, draft},
  howpublished = {\url{https://github.com/SynapticFour/technical-reports/tree/main/reports/SF-TR-2026-001}}
}
```

Add a note that the citation refers to a draft without peer archival. Update citations when a DOI is minted.

## In-Report Cross-References

When one SF-TR report cites another, add the entry to `references.bib` after the cited report is published with a DOI. Illustrative shape:

```bibtex
@techreport{synapticfour2026example,
  author      = {{Synaptic Four}},
  title       = {Example Report Title},
  institution = {Synaptic Four},
  number      = {SF-TR-YYYY-NNN},
  year        = {2026},
  doi         = {10.5281/zenodo.XXXXXXX}
}
```

## Author ORCIDs

Include ORCIDs in report front matter for disambiguation. Zenodo and Crossref propagate ORCIDs when present in deposit metadata.

## License Attribution

Reports default to [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Cite the report and DOI; attribute Synaptic Four as author. Do not imply endorsement.

## For Authors: Checklist Before Release

- [ ] `doi` field populated in `paper.qmd` after Zenodo publish
- [ ] BibTeX entry added to `references.bib` if cross-cited by other reports
- [ ] `catalog.yaml` includes `doi` and `zenodo` URLs
- [ ] synapticfour.com page displays DOI with link
- [ ] Optional: per-report `CITATION.cff` in report directory

## Related Documents

- [zenodo-integration.md](zenodo-integration.md)
- [workflow.md](workflow.md)
