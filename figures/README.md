# Shared Figures

Repository-level figures used across multiple technical reports.

## Usage

Reference from any report:

```markdown
![Synaptic Four report series logo](figures/shared-diagram.png){#fig-shared width=70%}
```

Use relative paths from the report directory:

```markdown
![Diagram](../../figures/shared-diagram.png)
```

## Report-Specific Figures

Figures used by a single report should live in that report's local `figures/` directory:

```
reports/SF-TR-2026-001/figures/architecture.png
```

## Guidelines

- SVG preferred for diagrams; PNG for screenshots and raster graphics
- Minimum 150 DPI for print-bound figures
- Descriptive filenames: `ferrum-api-sequence.svg`, not `figure3.png`
- Include source files (`.mmd`, `.drawio`, `.excalidraw`) when practical
