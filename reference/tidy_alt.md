# Extract Tidy Parameter Estimates from an alt Object.

Returns tidy data frames of per-stress-level parameter estimates and
(when available) global life-stress relationship coefficients from a
fitted \`alt\` object. Useful for reporting ALT results in reproducible
research workflows.

## Usage

``` r
tidy_alt(alt_obj)
```

## Arguments

- alt_obj:

  An object of class \`'alt'\` created by the \`WeibullR.ALT\` package.
  Must have been processed through \[WeibullR.ALT::alt.parallel()\]. For
  \`\$relationship\` to be non-NULL, \[WeibullR.ALT::alt.fit()\] must
  also have been called.

## Value

A named list with two elements:

- \`parallel\`:

  A \`data.frame\` with one row per stress level, containing columns
  \`stress\`, \`P1\`, \`P2\`, \`wt\`, and \`n_failures\`. For Weibull
  models, \`P1\` is the scale parameter \\\eta\\ and \`P2\` is the shape
  parameter \\\beta\\. For lognormal models, \`P1\` is \\\mu\_{log}\\
  and \`P2\` is \\\sigma\_{log}\\.

- \`relationship\`:

  A one-row \`data.frame\` with columns \`model\`, \`coef1\`, and
  \`coef2\` (the global life-stress relationship coefficients), or
  \`NULL\` with a message if \`alt.fit()\` has not been called.

## Details

Two life-stress models are supported. For the Arrhenius model, \\\eta =
\exp(C_1 + C_2 \cdot S)\\ where \\S\\ is stress (typically reciprocal
temperature in 1/K). For the Power Law model, \\\eta = \exp(C_1) /
S^{\|C_2\|}\\. Both `coef1` and `coef2` are on the log scale as returned
by [`alt.fit()`](https://rdrr.io/pkg/WeibullR.ALT/man/alt.fit.html).

## References

Nelson, W. B. (1990). *Accelerated Testing: Statistical Models, Test
Plans, and Data Analysis*. Wiley.

## See also

\[plotly_alt()\] for the ALT probability plot, \[plotly_rel()\] for the
life-stress relationship plot.

## Examples

``` r
library(WeibullR.ALT)
d1 <- alt.data(c(248, 456, 528, 731, 813, 537), stress = 300)
d2 <- alt.data(c(164, 176, 289), stress = 350)
d3 <- alt.data(c(88, 112, 152), stress = 400)
obj <- alt.fit(
  alt.parallel(
    alt.make(list(d1, d2, d3), dist = "weibull", alt.model = "arrhenius",
             view_dist_fits = FALSE),
    view_parallel_fits = FALSE
  )
)
result <- tidy_alt(obj)
result$parallel
#>   stress       P1       P2 wt n_failures
#> 1    300 615.9660 3.935945  6          6
#> 2    350 231.8588 3.935945  3          3
#> 3    400 128.0115 3.935945  3          3
result$relationship
#>       model    coef1       coef2
#> 1 arrhenius 11.20605 -0.01605895
```
