# Publications Index

Machine-readable catalogue of all Synaptic Four Technical Reports.

## Files

| File | Purpose |
|------|---------|
| `catalog.yaml` | Authoritative index of all reports and metadata |
| `README.md` | This file |

## Index Schema

Each report entry in `catalog.yaml` should include:

| Field | Required | Description |
|-------|----------|-------------|
| `id` | Yes | Report identifier (`SF-TR-YYYY-NNN`) |
| `title` | Yes | Full report title |
| `category` | Yes | Publication category (see [docs/publication-categories.md](../docs/publication-categories.md)) |
| `status` | Yes | `draft`, `in_review`, `published`, `revised`, or `withdrawn` |
| `version` | Recommended | Semantic version of current release |
| `date` | Recommended | Publication date (ISO 8601) |
| `authors` | Recommended | Author list |
| `abstract` | Recommended | Short abstract for discovery |
| `keywords` | Optional | Search keywords |
| `doi` | When published | Zenodo DOI |
| `zenodo` | When published | Zenodo record URL |
| `github_release` | When published | GitHub Release URL |
| `website` | When published | synapticfour.com publication page |
| `path` | Recommended | Repository path to report source |
| `formats` | Optional | Available output formats (`html`, `pdf`) |

## Status Values

| Status | Meaning |
|--------|---------|
| `draft` | In preparation; not publicly released |
| `in_review` | Internal or external review in progress |
| `published` | Released with GitHub tag and DOI |
| `revised` | Superseded by a newer version; prior DOI still valid |
| `withdrawn` | Removed from active distribution; DOI retained for audit |

## Maintenance

1. Add a new entry when allocating a report number (status: `draft`).
2. Update metadata when creating a GitHub Release.
3. Add `doi` and `zenodo` fields after Zenodo archival.
4. Add `website` when the synapticfour.com page is live.

The [validate-index workflow](../.github/workflows/validate-index.yml) checks schema consistency on every change to this directory.
