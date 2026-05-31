# ReliaPlotR: Interactive Reliability Plots with plotly

ReliaPlotR creates interactive reliability probability plots using
[plotly](https://plotly.com/r/). It wraps the WeibullR, WeibullR.ALT,
and ReliaGrowR packages and provides a consistent interface for four
reliability analysis domains:

## Details

- Life Data Analysis:

  \[plotly_wblr()\], \[plotly_contour()\]

- Accelerated Life Testing:

  \[plotly_alt()\], \[plotly_rel()\]

- Reliability Growth:

  \[plotly_rga()\], \[plotly_duane()\]

- Repairable Systems:

  \[plotly_nhpp()\], \[plotly_mcf()\], \[plotly_exposure()\]

All functions accept a single fitted model object or a list of objects
(for overlay plots) and return a `plotly` object.

## See also

Vignettes:

- [`vignette("weibull", package = "ReliaPlotR")`](https://paulgovan.github.io/ReliaPlotR/articles/weibull.md)
  — Life Data Analysis

- [`vignette("alt", package = "ReliaPlotR")`](https://paulgovan.github.io/ReliaPlotR/articles/alt.md)
  — Accelerated Life Testing

- [`vignette("rga", package = "ReliaPlotR")`](https://paulgovan.github.io/ReliaPlotR/articles/rga.md)
  — Reliability Growth Analysis

- [`vignette("repairable", package = "ReliaPlotR")`](https://paulgovan.github.io/ReliaPlotR/articles/repairable.md)
  — Repairable Systems Analysis

## Author

**Maintainer**: Paul Govan <paul.govan2@gmail.com>
([ORCID](https://orcid.org/0000-0002-1821-8492)) \[copyright holder\]
