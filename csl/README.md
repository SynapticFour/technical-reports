# Citation Style Language (CSL)

CSL files control bibliography formatting in rendered reports.

## Included Styles

| File | Style | Typical use |
|------|-------|-------------|
| `ieee.csl` | IEEE | Default for technical reports |

## Changing Style

Set in report `paper.qmd` front matter or project `_quarto.yml`:

```yaml
csl: ../../csl/ieee.csl
```

## Adding Styles

Download additional styles from the [CSL Style Repository](https://github.com/citation-style-language/styles):

```bash
curl -o csl/nature.csl \
  https://raw.githubusercontent.com/citation-style-language/styles/master/nature.csl
```

Common alternatives for journal adaptation:

- `nature.csl` — Nature family journals
- `apa.csl` — APA 7th edition
- `vancouver.csl` — Biomedical journals

When adapting a report for journal submission, switch CSL to match the target journal and re-render.
