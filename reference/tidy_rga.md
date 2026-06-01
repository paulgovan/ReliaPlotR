# Extract Tidy Fitted Values from an rga Object.

Returns a tidy data frame of fitted cumulative failure counts,
confidence bounds, and (when available) Crow-AMSAA model coefficients
from an \`rga\` object. Suitable for exporting results for use in
reproducible research workflows.

## Usage

``` r
tidy_rga(rga_obj)
```

## Arguments

- rga_obj:

  An object of class \`'rga'\`, or a list of such objects. Each object
  is created using the \[ReliaGrowR::rga()\] function.

## Value

A named list with two elements:

- \`fitted\`:

  For a single object, a \`data.frame\` with columns \`time\`,
  \`cum_failures\`, \`fitted\`, \`lower\`, \`upper\`. For a list, a list
  of such data frames (one per object).

- \`params\`:

  For a single object, a one-row \`data.frame\` with columns \`lambda\`
  and \`beta\` (Crow-AMSAA Power Law parameters), or \`NULL\` if the
  model coefficients cannot be extracted. For a list, a list of such
  data frames.

## Details

The Crow-AMSAA (NHPP Power Law) model gives the expected cumulative
failures as \\E\[N(t)\] = \lambda t^\beta\\. A \\\beta \< 1\\ indicates
reliability growth (decreasing failure rate); \\\beta \> 1\\ indicates
degradation. The parameters are recovered from the fitted log-log linear
model via [`coef()`](https://rdrr.io/r/stats/coef.html): \\\lambda =
\exp(\text{intercept})\\ and \\\beta\\ is the slope coefficient.

## References

Crow, L. H. (1974). Reliability Analysis for Complex Repairable Systems.
In *Reliability and Biometry*, SIAM, pp. 379-410.

## See also

\[plotly_rga()\] for the corresponding interactive reliability growth
plot.

## Examples

``` r
library(ReliaGrowR)
times <- c(100, 200, 300, 400, 500)
failures <- c(1, 2, 1, 3, 2)
obj <- rga(times, failures)
result <- tidy_rga(obj)
result$fitted
#>   time cum_failures   fitted     lower     upper
#> 1  100            1 1.065602 0.7656742  1.483017
#> 2  300            3 2.562478 2.1157687  3.103503
#> 3  600            4 4.457440 3.7410494  5.311015
#> 4 1000            7 6.703022 5.4093372  8.306102
#> 5 1500            9 9.266388 7.1120671 12.073275
result$params
#>       lambda      beta
#> 1 0.02693046 0.7986756
```
