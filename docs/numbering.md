# Technical Report Numbering

## Identifier Format

```
SF-TR-YYYY-NNN
```

| Segment | Rule |
|---------|------|
| `SF-TR` | Fixed prefix for Synaptic Four Technical Reports |
| `YYYY`  | Four-digit calendar year of **initial publication** |
| `NNN`   | Three-digit sequence number, zero-padded (`001`–`999`) |

The identifier is **permanent**. It does not change when a report is revised, translated, or adapted for journal submission.

## Allocation Rules

1. **One identifier per report topic.** A new architectural direction or distinct deliverable receives a new number. Minor revisions retain the same identifier.
2. **Sequence resets annually.** Each calendar year begins at `001`.
3. **First-come allocation.** Numbers are assigned when work begins, registered in `publications-index/catalog.yaml` with status `draft`, and reserved even if publication is delayed.
4. **No gaps by design.** Use the next available number in the current year. Do not skip numbers for perceived importance.
5. **No reuse.** Withdrawn reports retain their identifier; the number is never reassigned.

## Examples

| Identifier | Meaning |
|------------|---------|
| `SF-TR-2026-001` | First report published (or initiated) in 2026 |
| `SF-TR-2026-002` | Second report in 2026 |
| `SF-TR-2027-001` | First report in 2027 |

## Versioning

Report **versions** are separate from report **numbers**:

| Concept | Format | Example |
|---------|--------|---------|
| Report ID | `SF-TR-YYYY-NNN` | `SF-TR-2026-001` |
| Release tag | `SF-TR-YYYY-NNN-vX.Y.Z` | `SF-TR-2026-001-v1.1.0` |
| DOI | Versioned via Zenodo | `10.5281/zenodo.1234567` (v1.0.0) |

Follow [semantic versioning](https://semver.org/) for releases:

- **MAJOR** — Substantial revision affecting conclusions or architecture
- **MINOR** — Additions, new sections, expanded benchmarks
- **PATCH** — Corrections, typographical fixes, clarifications

## Directory and File Naming

```
reports/SF-TR-YYYY-NNN/
  paper.qmd
  references.bib
  figures/
```

Use lowercase slugs on the website: `sf-tr-2026-001`.

## Related Documents

- [workflow.md](workflow.md) — Release and DOI process
- [publications-index/README.md](../publications-index/README.md) — Index registration
