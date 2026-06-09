# Contributor Guidance

How to contribute to the Synaptic Four Technical Report Series.

## Who Can Contribute

- Synaptic Four engineering and research staff (primary authors)
- Collaborators with documented co-authorship agreement
- External contributors via pull request (with maintainer approval)

## Getting Started

### Prerequisites

- [Quarto](https://quarto.org/docs/get-started/) ≥ 1.4
- [TinyTeX](https://yihui.org/tinytex/) or full TeX distribution (for PDF)
- Git
- Text editor or IDE with Markdown support

### Local setup

```bash
git clone https://github.com/SynapticFour/technical-reports.git
cd technical-reports

# Verify Quarto
quarto --version

# Copy template for a new report (after number allocation)
cp -r templates/SF-TR-YYYY-NNN-template reports/SF-TR-2026-001
cd reports/SF-TR-2026-001
quarto render paper.qmd
```

## Contribution Workflow

1. **Allocate a report number** — Coordinate with the series maintainer; add draft entry to `publications-index/catalog.yaml`.
2. **Create a branch** — `git checkout -b report/SF-TR-2026-001-ferrum-architecture`
3. **Author content** — Edit `paper.qmd`, `references.bib`, and figures.
4. **Render locally** — Confirm HTML and PDF build without errors.
5. **Open a pull request** — Against `main`; include report ID in PR title.
6. **Review** — Address technical and editorial feedback.
7. **Merge** — Maintainer merges after approval.
8. **Release** — Maintainer creates GitHub Release and Zenodo deposit (see [workflow.md](workflow.md)).

## Writing Standards

### Voice and tone

- Technical, precise, neutral
- Active voice where possible
- No marketing superlatives ("best-in-class", "revolutionary")
- Define acronyms on first use

### Structure

- Follow the template section order unless category guidance suggests otherwise
- Keep sections focused; split long sections with subsections
- Use numbered figures and tables with captions
- Cross-reference sections and figures

### Figures

- Prefer SVG or PNG at ≥150 DPI for print
- Store in `reports/SF-TR-YYYY-NNN/figures/`
- Use Mermaid for diagrams when source-controlled text format is preferred
- Include alt text or descriptive captions for accessibility

### Code

- Use fenced code blocks with language tags
- Keep code snippets minimal and illustrative
- Link to external repositories for full implementations

### References

- Add all citations to `references.bib`
- Prefer DOIs for academic references
- Include version numbers for standards and specifications
- Use `@citation_key` syntax in prose

## Front Matter Requirements

Every `paper.qmd` must include:

```yaml
report-id: SF-TR-YYYY-NNN
report-category: <category>
version: "X.Y.Z"
license: CC BY 4.0
```

Populate `doi` after Zenodo publication.

## Pull Request Checklist

- [ ] Report ID allocated and registered in `catalog.yaml`
- [ ] `quarto render paper.qmd` succeeds locally
- [ ] All template placeholder text replaced or removed
- [ ] References complete and cited in text
- [ ] Figures render correctly in HTML and PDF
- [ ] No secrets, credentials, or sensitive deployment details
- [ ] Limitations section is honest and complete
- [ ] Changelog appendix updated for revisions

## Review Criteria

| Reviewer | Focus |
|----------|-------|
| Technical | Accuracy, architecture, implementation detail |
| Editorial | Clarity, grammar, structure, consistency |
| Security | No sensitive data; appropriate threat model |
| Series maintainer | Numbering, index, metadata, process compliance |

## Commit Messages

Use conventional prefixes:

```
docs(SF-TR-2026-001): add deployment section
fix(SF-TR-2026-001): correct DRS endpoint reference
chore(catalog): register SF-TR-2026-006 draft
```

## Licensing

Report content defaults to [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Authors retain copyright; Synaptic Four is the publisher. Alternative licensing requires explicit approval in front matter.

## Questions

- Series process: see [workflow.md](workflow.md)
- Citation format: see [citation-guide.md](citation-guide.md)
- Category selection: see [publication-categories.md](publication-categories.md)
- Contact: [contact@synapticfour.com](mailto:contact@synapticfour.com)
