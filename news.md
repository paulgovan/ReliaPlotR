# ReliaPlotR 0.7

## New features

- New
  [`tidy_wblr()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_wblr.md)
  function extracts parameter estimates, goodness-of-fit metrics, and
  confidence bounds from fitted `wblr` objects as tidy data frames.
- New
  [`tidy_rga()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_rga.md)
  function extracts fitted cumulative failure counts, confidence bounds,
  and Crow-AMSAA model coefficients from `rga` objects.
- New
  [`tidy_alt()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_alt.md)
  function extracts per-stress-level parameter estimates and life-stress
  relationship coefficients from fitted `alt` objects.
- New
  [`reliapltr_mcp_server()`](https://paulgovan.github.io/ReliaPlotR/reference/reliapltr_mcp_server.md)
  exposes `fit_weibull` and `fit_alt` as MCP tools for use with Claude
  Code and Claude Desktop (requires `mcptools` and `ellmer`).
- New vignette “MCP Tools” covers registering the server and using both
  tools.
- All four vignettes now include a **Statistical Background** section
  with equations, parameter interpretation, and references.
- New `inst/REFERENCES.bib` with BibTeX entries for foundational
  reliability engineering references.

# ReliaPlotR 0.6

## Minor improvements and bug fixes

- [`plotly_nhpp()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_nhpp.md)
  now plots the Mean Cumulative Function (MCF) instead of raw cumulative
  failures.
- Fixed confidence bounds rendering order in
  [`plotly_nhpp()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_nhpp.md).

# ReliaPlotR 0.5

## New features

- New
  [`plotly_alt()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_alt.md)
  function for Accelerated Life Testing (ALT) probability plots, with
  one line per stress level.
- New
  [`plotly_rel()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_rel.md)
  function for ALT life-stress relationship plots.
- New
  [`plotly_mcf()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_mcf.md)
  function for Mean Cumulative Function (MCF) plots for repairable
  systems.
- New
  [`plotly_nhpp()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_nhpp.md)
  function for Non-Homogeneous Poisson Process (NHPP) reliability growth
  plots.
- New
  [`plotly_exposure()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_exposure.md)
  function for exposure plots.
- [`plotly_wblr()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_wblr.md),
  [`plotly_rga()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_rga.md),
  and
  [`plotly_contour()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_contour.md)
  now accept a list of model objects for overlaying multiple fits on a
  single plot.
- New vignettes on ALT analysis and repairable systems analysis.

## Minor improvements and bug fixes

- Various improvements to
  [`plotly_wblr()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_wblr.md)
  and
  [`plotly_rga()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_rga.md).
- Other minor improvements and bug fixes.

# ReliaPlotR 0.4.1

## Minor improvements

- New confidence bounds option for the Duane plot in `plotly_duane`.
- Results table is removed from `plotly_wblr` to reduce clutter.
- Other minor improvements and bug fixes.

# ReliaPlotR 0.4 (formerly WeibullR.plotly)

- The package has been renamed from `WeibullR.plotly` to `ReliaPlotR` to
  better reflect its broader focus on reliability engineering topics
  beyond just Weibull analysis.
- Updated DESCRIPTION and documentation to reflect the new package name.
- Other minor improvements and bug fixes.

# WeibullR.plotly 0.3.2

## Bug fix

- Fixes bug with `duane` function.
- Other minor improvements and bug fixes.

# WeibullR.plotly 0.3.1

## Minor improvements and fixes

- Minor improvements and bug fixes

# WeibullR.plotly 0.3

- Now with support for Reliability Growth Analysis via the
  `plotly_duane` and `plotly_rga` functions.
- New vignettes on Weibull Analysis and Reliability Growth Analysis.
- Other minor improvements and bug fixes.

# WeibullR.plotly 0.2.1

## Minor improvements and fixes

- Add unit tests
- Update webpage
- Update contact information

# WeibullR.plotly 0.2

## Minor improvements and fixes

- `plotly_wblr` now has a lognormal plotting canvas.
- Both `plotly_wblr` and `plotly_contour` have more plotting options.

# WeibullR.plotly 0.1.5

## Minor improvements and fixes

- `plotly_wblr` no longer gives warning message (issue \#2).

# WeibullR.plotly 0.1.4

## Minor improvements and fixes

- `plotly_wblr` now has different subplot options.
- `plotly_wblr` and `plotly_contour` no longer plot messages to the
  console.
- Updated docs.

# WeibullR.plotly 0.1.2

## Initial release

- `plotly_wblr` function.
- `plotly_contour` function.
