# Accelerated Life Testing (ALT)

``` r
library(ReliaPlotR)
library(WeibullR)
library(WeibullR.ALT)
```

## Building an ALT Model

The `WeibullR.ALT` package uses a three-step pipeline to create an ALT
model.

**Step 1 — Create data sets** for each stress level using
[`alt.data()`](https://rdrr.io/pkg/WeibullR.ALT/man/alt.data.html):

``` r
d1 <- alt.data(c(248, 456, 528, 731, 813, 537), stress = 300)
d2 <- alt.data(c(164, 176, 289), stress = 350)
d3 <- alt.data(c(88, 112, 152), stress = 400)
```

**Step 2 — Fit parallel models** across stress levels using
[`alt.make()`](https://rdrr.io/pkg/WeibullR.ALT/man/alt.make.html) and
[`alt.parallel()`](https://rdrr.io/pkg/WeibullR.ALT/man/alt.parallel.html):

``` r
obj <- alt.parallel(
  alt.make(list(d1, d2, d3), dist = "weibull", alt.model = "arrhenius", view_dist_fits = FALSE),
  view_parallel_fits = FALSE
)
```

**Step 3 — Fit the life-stress relationship** using
[`alt.fit()`](https://rdrr.io/pkg/WeibullR.ALT/man/alt.fit.html):

``` r
obj <- alt.fit(obj)
```

## ALT Probability Plot

[`plotly_alt()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_alt.md)
overlays one probability-paper fit line per stress level. Data points
show empirical plotting positions; lines show the theoretical Weibull
(or lognormal) fit. Click a legend entry to toggle a stress level on or
off.

``` r
plotly_alt(obj)
```

### Customization

The plot accepts several optional arguments:

``` r
plotly_alt(
  obj,
  main    = "Reliability Test Results",
  xlab    = "Hours to Failure",
  cols    = c("#1f77b4", "#ff7f0e", "#2ca02c"),
  showGrid = FALSE
)
```

## Life-Stress Relationship Plot

[`plotly_rel()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_rel.md)
displays how characteristic life (eta for Weibull, median life for
lognormal) changes with stress level, along with the fitted Arrhenius or
Power Law relationship.

``` r
plotly_rel(obj)
```

The plot includes:

- **Points** (×) — characteristic-life estimates from parallel fits at
  each stress level
- **Red line** — fitted life-stress relationship (Arrhenius or Power
  Law)
- **Dashed blue lines** — percentile bands (10th and 90th by default)

### Percentile Bands

Use the `percentiles` argument to change which percentile bands are
shown:

``` r
plotly_rel(obj, percentiles = c(5, 50, 95))
```

### Hiding Percentile Lines

Set `showPerc = FALSE` to show only the fitted relationship line:

``` r
plotly_rel(obj, showPerc = FALSE)
```

### Customization

``` r
plotly_rel(
  obj,
  main    = "Arrhenius Life-Stress Relationship",
  fitCol  = "darkgreen",
  percCol = "steelblue",
  signif  = 4
)
```
