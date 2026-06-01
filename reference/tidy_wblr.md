# Extract Tidy Parameter Estimates from a wblr Object.

Returns a tidy data frame of distribution parameter estimates,
goodness-of-fit metrics, and (optionally) confidence bound data from one
or more fitted \`wblr\` objects. This makes it straightforward to use
ReliaPlotR output in reproducible research workflows — export to CSV,
include in tables, or compare multiple fits.

## Usage

``` r
tidy_wblr(wblr_obj)
```

## Arguments

- wblr_obj:

  A single object of class \`'wblr'\`, or a list of such objects. Each
  object must have been fitted with \[WeibullR::wblr.fit()\].

## Value

A named list with two elements:

- \`estimates\`:

  A \`data.frame\` with one row per \`wblr\` object and columns
  \`dist\`, \`method_fit\`, \`param1_name\`, \`param1\`,
  \`param2_name\`, \`param2\`, \`param3_name\`, \`param3\`,
  \`gof_metric\`, \`gof_value\`, \`method_conf\`, \`n_failures\`.

- \`bounds\`:

  For a single object, a \`data.frame\` of confidence bound data
  (columns \`Datum\`, \`unrel\`, \`Lower\`, \`Upper\`), or \`NULL\` if
  no confidence bounds were computed. For a list of objects, a list of
  such data frames (one per object).

## Details

Parameters are returned on their natural scales. For Weibull and
three-parameter Weibull (`weibull3p`) models, `param1` is the shape
parameter \\\beta\\ and `param2` is the scale parameter \\\eta\\;
`param3` is the location parameter \\\gamma\\ for `weibull3p` (NA
otherwise). For lognormal models, `param1` is \\\mu\_{log}\\ and
`param2` is \\\sigma\_{log}\\.

Goodness-of-fit is reported as R\\^2\\ (column value `"R2"`) for
rank-regression fits, or log-likelihood (`"loglikelihood"`) for MLE
fits.

## References

Meeker, W. Q., and Escobar, L. A. (1998). *Statistical Methods for
Reliability Data*. Wiley.

## See also

\[plotly_wblr()\] for the corresponding interactive probability plot.

## Examples

``` r
library(WeibullR)
failures <- c(30, 49, 82, 90, 96)
obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
result <- tidy_wblr(obj)
result$estimates
#>      dist method_fit param1_name   param1 param2_name   param2 param3_name
#> 1 weibull        mle        Beta 3.201164         Eta 77.81167        <NA>
#>   param3    gof_metric gof_value method_conf n_failures
#> 1     NA loglikelihood -23.18159         lrb          5
result$bounds
#>         unrel       Lower      Datum     Upper
#> 1  0.00100000   0.8201964   8.994013  25.05510
#> 2  0.00159195   1.1035497  10.400967  27.18641
#> 3  0.00253387   1.4847969  12.028028  29.49903
#> 4  0.00403197   1.9977530  13.909610  32.00837
#> 5  0.00641293   2.6879185  16.085526  34.75190
#> 6  0.01000000   3.5725395  18.490693  37.67812
#> 7  0.01019270   3.6165201  18.601836  37.80935
#> 8  0.01618200   4.8659190  21.511761  41.13577
#> 9  0.02564490   6.5262567  24.876932  44.75489
#> 10 0.04052620   8.7488200  28.768488  48.69237
#> 11 0.05000000  10.0177170  30.767007  50.62715
#> 12 0.06375590  11.7283061  33.268827  53.04285
#> 13 0.09959220  15.6534757  38.473177  57.91256
#> 14 0.10000000  15.6952069  38.524998  57.95969
#> 15 0.15384900  20.8670185  44.491660  63.42913
#> 16 0.23358100  27.6169274  51.451612  69.92800
#> 17 0.34533200  36.2882885  59.500349  78.13636
#> 18 0.49063700  47.0846133  68.808168  89.51058
#> 19 0.50000000  47.7912968  69.393815  90.31199
#> 20 0.63212100  57.7105486  77.811696 103.13132
#> 21 0.65844300  59.7490783  79.572030 106.12223
#> 22 0.81925100  73.4712661  92.019690 130.37138
#> 23 0.93439300  86.7656001 106.414574 165.07900
#> 24 0.98693600  98.6657162 123.061441 213.44348
#> 25 0.99900000 109.5876555 142.312200 279.89645

# List of objects
obj2 <- wblr.conf(wblr.fit(wblr(c(20, 40, 60, 80, 100)), method.fit = "mle"),
                  method.conf = "lrb")
result2 <- tidy_wblr(list(obj, obj2))
result2$estimates
#>      dist method_fit param1_name   param1 param2_name   param2 param3_name
#> 1 weibull        mle        Beta 3.201164         Eta 77.81167        <NA>
#> 2 weibull        mle        Beta 2.291879         Eta 67.85171        <NA>
#>   param3    gof_metric gof_value method_conf n_failures
#> 1     NA loglikelihood -23.18159         lrb          5
#> 2     NA loglikelihood -23.64976         lrb          5
```
