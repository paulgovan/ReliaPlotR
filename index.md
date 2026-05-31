# ReliaPlotR

Build interactive reliability plots with `plotly`, an interactive
web-based graphing library. ReliaPlotR wraps the **WeibullR**,
**WeibullR.ALT**, and **ReliaGrowR** packages to produce interactive
visualizations across four reliability analysis domains.

## Function Overview

| Function | Analysis Domain | Purpose |
|----|----|----|
| [`plotly_wblr()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_wblr.md) | Life Data Analysis | Weibull/lognormal probability plot |
| [`plotly_contour()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_contour.md) | Life Data Analysis | MLE parameter confidence contour plot |
| [`plotly_alt()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_alt.md) | Accelerated Life Testing | ALT probability plot (one line per stress level) |
| [`plotly_rel()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_rel.md) | Accelerated Life Testing | ALT life-stress relationship plot |
| [`plotly_rga()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_rga.md) | Reliability Growth | Crow-AMSAA / NHPP cumulative failures plot |
| [`plotly_duane()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_duane.md) | Reliability Growth | Duane cumulative MTBF plot (log-log) |
| [`plotly_nhpp()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_nhpp.md) | Repairable Systems | NHPP MCF plot with parametric model overlay |
| [`plotly_mcf()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_mcf.md) | Repairable Systems | Nonparametric Mean Cumulative Function plot |
| [`plotly_exposure()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_exposure.md) | Repairable Systems | Cumulative event rate (exposure) plot |

All functions accept a single model object or a **list** of objects for
overlay plots, and return a `plotly` object for interactive use.

## Getting Started

To install `ReliaPlotR` in R:

``` r

install.packages("ReliaPlotR")
```

Or install the development version:

``` r

devtools::install_github("paulgovan/ReliaPlotR")
```

## Basic Examples

To build a probability plot, first fit a `wblr` object using the
`WeibullR` package and then use `plotly_wblr` to build the plot.

``` r

library(WeibullR)
library(ReliaPlotR)
failures <- c(30, 49, 82, 90, 96)
obj <- wblr.conf(wblr.fit(wblr(failures)))
plotly_wblr(obj)
```

![](https://raw.githubusercontent.com/paulgovan/ReliaPlotR/main/ReadMe_files/figure-gfm/unnamed-chunk-3-1.png)

To build a contour plot, use the `plotly_contour` function. Note that
contour plots are only available where `method.fit='mle'` and
`method.conf='lrb'`.

``` r

obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
plotly_contour(obj)
```

![](https://raw.githubusercontent.com/paulgovan/ReliaPlotR/main/ReadMe_files/figure-gfm/unnamed-chunk-4-1.png)

## Customization

`ReliaPlotR` has several customization options.

``` r

plotly_wblr(obj, main = "Weibull Probability Plot", xlab = "Years", ylab = "Failure Probability", confCol = "blue", signif = 4, grid = FALSE)
```

![](https://raw.githubusercontent.com/paulgovan/ReliaPlotR/main/ReadMe_files/figure-gfm/unnamed-chunk-5-1.png)

``` r

plotly_contour(obj, main = "Weibull Contour Plot", col = "red", signif = 4, grid = FALSE)
```

![](https://raw.githubusercontent.com/paulgovan/ReliaPlotR/main/ReadMe_files/figure-gfm/unnamed-chunk-6-1.png)

## Vignettes

For detailed worked examples see the package vignettes:

- [Life Data
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/weibull.html)
- [Accelerated Life
  Testing](https://paulgovan.github.io/ReliaPlotR/articles/alt.html)
- [Reliability Growth
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/rga.html)
- [Repairable Systems
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/repairable.html)

## Code of Conduct

Please note that the ReliaPlotR project is released with a [Contributor
Code of
Conduct](https://github.com/paulgovan/ReliaPlotR/blob/f919aeb72a1d4dd3a64e55221eb1ae214b3480f5/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
