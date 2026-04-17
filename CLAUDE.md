# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

ReliaPlotR is an R package that creates interactive reliability probability plots using plotly. It wraps two upstream packages: **WeibullR** (for Weibull/lognormal distribution fitting) and **ReliaGrowR** (for reliability growth models), and produces interactive plotly visualizations.

## Common Commands

```r
# Run all tests
devtools::test()

# Run a single test file
testthat::test_file("tests/testthat/test-wblr.R")

# Rebuild documentation (after editing roxygen2 comments)
roxygen2::roxygenise()

# Check the full package (CRAN-style)
devtools::check()

# Build pkgdown site
pkgdown::build_site()

# Check test coverage
covr::package_coverage()

# Spell check
spelling::spell_check_package()
```

## Architecture

The package exports six functions, each in its own file under `R/`:

| Function | File | Input type | Purpose |
|---|---|---|---|
| `plotly_wblr()` | `R/plotly_wblr.R` | `wblr` object or list of them | Weibull/lognormal probability plot |
| `plotly_contour()` | `R/plotly_contour.R` | `wblr` object or list of them | Parameter confidence contour plot |
| `plotly_rga()` | `R/plotly_rga.R` | `rga` object or list of them | Reliability growth (NHPP) plot |
| `plotly_duane()` | `R/plotly_duane.R` | `duane` object (ReliaGrowR) | Duane MTBF plot (log-log scale) |
| `plotly_alt()` | `R/plotly_alt.R` | `alt` object (WeibullR.ALT) | ALT probability plot (one line per stress level) |
| `plotly_rel()` | `R/plotly_rel.R` | `alt` object (WeibullR.ALT) | ALT life-stress relationship plot |

All functions follow the same interface conventions: accept a model object, optional display flags (`showConf`, `showGrid`, `showSusp`), axis labels, and color parameters. All return a plotly object.

### ALT pipeline

`plotly_alt` and `plotly_rel` both require a fully-fitted `alt` object from `WeibullR.ALT`. The three-step pipeline is `alt.make()` → `alt.parallel()` → `alt.fit()`. `plotly_alt` requires at minimum `alt.parallel()` (needs `$parallel_par`); `plotly_rel` additionally requires `alt.fit()` (needs `$alt_coef`). Both functions internally call `WeibullR::wblr()` to compute empirical plotting positions from the raw `$data` entries.

### Overlay pattern

`plotly_wblr`, `plotly_rga`, and `plotly_contour` all accept either a single model object or a `list` of objects. `plotly_alt` handles multiple stress levels from one `alt` object using an internal loop (not a list API). When a list is provided:
- Each object is rendered in a distinct color from a 10-color default palette (same palette across all three functions).
- A `cols` parameter accepts an explicit color vector, recycled to match the number of objects.
- For single objects, the existing per-element color params (`probCol`, `fitCol`, `confCol`, etc.) still apply.
- `plotly_wblr` requires all objects to share the same distribution type and ignores `susp` (with a warning) when multiple objects are passed.
- The plot is built by initializing an empty `plot_ly()` then looping through objects, appending traces for each. A single `layout()` call is applied once after the loop.
- `legendgroup` is set per object so clicking a legend entry toggles all traces for that object.

### plotly_wblr() internals

This is the most complex function (376 lines). Key details:
- Weibull plots use log scale on y-axis with custom tick marks at probability percentiles; lognormal plots use `qnorm` (linear scale).
- Supports 2-parameter and 3-parameter Weibull (`dist='weibull3p'`).
- When suspension data is passed via `susp`, a subplot is added below the main plot.
- Interval censored data (`$interval_data`) is extracted and plotted separately.
- Confidence bounds use `toRGB()` with alpha 0.2 for semi-transparent fills.
- Goodness-of-fit is shown via R² (for rank regression) or log-likelihood (for MLE).

### plotly_contour() internals

- Requires that the wblr object was fitted with `method.fit='mle'` and `method.conf='lrb'`.
- Accepts either a single wblr object or a list of them for overlaying multiple contours.
- MLE point estimates are shown as markers on top of each contour.

### Test structure

Tests live in `tests/testthat/`. Tests for `rga` and `duane` use manually constructed mock objects (S3 class `rga`/`duane`) because creating real ReliaGrowR model objects in tests requires fitting models. When modifying `plotly_rga()` or `plotly_duane()`, check what fields the mock objects expose to understand the expected structure.

### CI/CD

GitHub Actions run on push/PR to main:
- `R-CMD-check.yaml`: Tests on macOS, Windows, and Ubuntu across R devel/release/oldrel-1
- `test-coverage.yaml`: Uploads to Codecov
- `pkgdown.yaml`: Deploys documentation to GitHub Pages
