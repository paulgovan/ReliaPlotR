# Accelerated Life Testing (ALT)

``` r

library(ReliaPlotR)
library(WeibullR)
library(WeibullR.ALT)
```

## Statistical Background

**Accelerated Life Testing (ALT)** subjects units to stress levels
(temperature, voltage, vibration, etc.) higher than use conditions in
order to induce failures faster. Life data collected at multiple stress
levels are then extrapolated to the use-condition stress using a
physics-motivated life-stress model (Nelson 1990).

**Life distributions.** At each stress level, failure times are modeled
with a Weibull or lognormal distribution. The *shape* parameter
($`\beta`$ for Weibull; $`\sigma_{\log}`$ for lognormal) is assumed
constant across stress levels (the distributions are parallel on
probability paper), while the *scale* parameter ($`\eta`$ for Weibull;
$`\exp(\mu_{\log})`$ for lognormal) varies with stress according to the
life-stress model.

**Life-stress models.** Two models are supported:

- **Arrhenius**: $`\eta(S) = A \exp(E_a / (k S))`$, where $`S`$ is
  temperature in Kelvin and $`E_a / k`$ is the activation energy divided
  by Boltzmann’s constant. The x-axis uses a reciprocal scale so the
  relationship is linear.
- **Power Law (Inverse Power)**: $`\eta(S) = A / S^n`$, where $`S`$ is a
  non-thermal stress. Both axes are log-transformed so the relationship
  is linear.

**Fitting.**
[`alt.parallel()`](https://rdrr.io/pkg/WeibullR.ALT/man/alt.parallel.html)
fits independent Weibull/lognormal models at each stress level;
[`alt.fit()`](https://rdrr.io/pkg/WeibullR.ALT/man/alt.fit.html) then
fits the global life-stress relationship by constraining the shape
parameter to be equal across stress levels (Nelson 1990; Meeker and
Escobar 1998).

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

## References

## See Also

- [Life Data
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/weibull.md)
  — fit Weibull/lognormal models at a single stress level
- [Reliability Growth
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/rga.md) —
  track reliability improvement over time
- [Repairable Systems
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/repairable.md)
  — analyze recurrent events with MCF and NHPP models

Meeker, William Q., and Luis A. Escobar. 1998. *Statistical Methods for
Reliability Data*. Wiley.

Nelson, Wayne B. 1990. *Accelerated Testing: Statistical Models, Test
Plans, and Data Analysis*. Wiley.
