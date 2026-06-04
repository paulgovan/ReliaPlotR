# MCP Tools

``` r

library(ReliaPlotR)
```

## Overview

The [Model Context Protocol](https://modelcontextprotocol.io) (MCP) is
an open standard that lets AI assistants call external tools as part of
a conversation. Two MCP servers together cover the full ReliaPlotR
analysis pipeline:

**ReliaPlotR server** —
[`reliapltr_mcp_server()`](https://paulgovan.github.io/ReliaPlotR/reference/reliapltr_mcp_server.md)
— life data and ALT analysis:

| Tool | What it does |
|----|----|
| `fit_weibull` | Fit a Weibull or lognormal distribution to time-to-failure data and return parameter estimates |
| `fit_alt` | Fit an ALT model across multiple stress levels and return life-stress relationship coefficients |
| `plot_weibull` | Fit a distribution and return a Weibull probability plot as a plotly JSON string |
| `plot_alt` | Fit an ALT model and return probability and life-stress plots as plotly JSON strings |
| `plot_rga` | Fit a Crow-AMSAA model and return a cumulative failure plot as a plotly JSON string |

**ReliaGrowR server** —
[`rga_mcp_server()`](https://paulgovan.github.io/ReliaGrowR/reference/rga_mcp_server.html)
— reliability growth and repairable systems:

| Tool | What it does |
|----|----|
| `rga` | Fit Crow-AMSAA reliability growth model; returns λ, β, and goodness-of-fit stats |
| `nhpp` | Fit a Power Law or Log-Linear NHPP process; returns model parameters |
| `duane` | Fit a Duane log-log growth model; returns slope, intercept, and GOF stats |
| `mcf` | Compute Nelson-Aalen MCF for repairable systems; returns time, MCF, and bounds |
| `predict_rga` | Forecast cumulative failures from a fitted Crow-AMSAA model |
| `predict_duane` | Forecast MTBF from a fitted Duane model |
| `rdt` | Reliability demonstration test planning — solve for required sample size or test time |
| `gof_rga` | Goodness-of-fit statistics (CvM, KS) for a Crow-AMSAA model |

## Installation

`mcptools` and `ellmer` are optional dependencies listed in `Suggests`.
Install them before starting the server:

``` r

pak::pak(c("mcptools", "ellmer"))
```

## Registering with Claude Code

Once the packages are installed, register both servers in your Claude
Code session.

**ReliaPlotR server** (life data and ALT analysis):

``` bash
# Option 1: inline (works with any R installation)
claude mcp add -s user reliapltr -- \
  Rscript -e "ReliaPlotR::reliapltr_mcp_server()"
```

``` bash
# Option 2: bundled launcher script (after package installation)
claude mcp add -s user reliapltr -- \
  Rscript $(Rscript -e "cat(system.file('mcp/server.R', package='ReliaPlotR'))")
```

**ReliaGrowR server** (reliability growth and repairable systems):

``` bash
claude mcp add -s user reliagrowR -- \
  Rscript -e "ReliaGrowR::rga_mcp_server()"
```

Confirm both servers are registered:

``` bash
claude mcp list
```

Once registered, Claude Code will offer all tools automatically whenever
it detects a reliability analysis task.

## The `fit_weibull` Tool

`fit_weibull` fits a Weibull or lognormal distribution to a vector of
failure times, optionally with right-censored (suspension) data, and
returns parameter estimates and a goodness-of-fit metric.

### Arguments

| Argument | Type | Default | Description |
|----|----|----|----|
| `failures` | numeric array | *required* | Failure times (positive numbers) |
| `suspensions` | numeric array | `NULL` | Right-censored times – units still operating at end of test |
| `dist` | string | `"weibull"` | Distribution: `"weibull"`, `"lognormal"`, or `"weibull3p"` |
| `method_fit` | string | `"mle"` | Estimation method: `"mle"` (recommended for censored data) or `"rr-xony"` (rank regression) |
| `method_conf` | string | `"lrb"` | Confidence bounds: `"lrb"` (likelihood-ratio, requires MLE) or `"fm"` (Fisher-matrix). Automatically switches to `"fm"` when rank regression is used. |

### Example

The following shows what the tool returns when called from an MCP
client. The same function can be invoked directly in R for testing:

``` r

# Five machines that failed at these times (hours)
tool <- ReliaPlotR:::.make_wblr_tool()
result <- tool(failures = c(30, 49, 82, 90, 96))
str(result)
#> List of 12
#>  $ dist       : chr "weibull"
#>  $ method_fit : chr "mle"
#>  $ param1_name: chr "Beta"
#>  $ param1     : num 3.2
#>  $ param2_name: chr "Eta"
#>  $ param2     : num 77.8
#>  $ param3_name: chr NA
#>  $ param3     : num NA
#>  $ gof_metric : chr "loglikelihood"
#>  $ gof_value  : num -23.2
#>  $ method_conf: chr "lrb"
#>  $ n_failures : int 5
```

The flat named list is serialized to JSON when returned over MCP.
`param1` is the Weibull shape parameter $`\beta`$; `param2` is the
characteristic life $`\eta`$.

Adding right-censored suspensions shifts the estimates to account for
units that did not fail:

``` r

result_susp <- tool(
  failures    = c(30, 49, 82, 90, 96),
  suspensions = c(100, 120, 150)
)
cat("Beta:", result_susp$param1, "\n")
#> Beta: 1.892207
cat("Eta: ", result_susp$param2, "\n")
#> Eta:  122.6721
```

## The `fit_alt` Tool

`fit_alt` runs the full ALT pipeline (`alt.make` → `alt.parallel` →
`alt.fit`) across multiple stress levels and returns per-stress-level
parameters alongside the fitted global life-stress relationship.

### Arguments

| Argument | Type | Default | Description |
|----|----|----|----|
| `stresses` | numeric array | *required* | One stress value per stress level, e.g. `[300, 350, 400]` |
| `failures_json` | string | *required* | JSON array of failure-time arrays, one inner array per stress level. Example: `'[[248,456,528],[164,176,289],[88,112,152]]'` |
| `dist` | string | `"weibull"` | Life distribution: `"weibull"` or `"lognormal"` |
| `alt_model` | string | `"arrhenius"` | Life-stress model: `"arrhenius"` (temperature) or `"power"` (non-thermal) |

### Example

``` r

tool_alt <- ReliaPlotR:::.make_alt_tool()
result_alt <- tool_alt(
  stresses      = c(300, 350, 400),
  failures_json = "[[248,456,528,731,813,537],[164,176,289],[88,112,152]]",
  dist          = "weibull",
  alt_model     = "arrhenius"
)
```

``` r

# Per-stress-level parameter estimates
result_alt$parallel
#>   stress       P1       P2 wt n_failures
#> 1    300 615.9660 3.935945  6          6
#> 2    350 231.8588 3.935945  3          3
#> 3    400 128.0115 3.935945  3          3

# Global Arrhenius life-stress relationship coefficients
result_alt$relationship
#> $model
#> [1] "arrhenius"
#> 
#> $coef1
#> [1] 11.20605
#> 
#> $coef2
#> [1] -0.01605895
```

The `P1` column in `$parallel` is the characteristic life $`\eta`$ at
each stress level (for Weibull) or $`\exp(\mu_{\log})`$ (for lognormal).
The `P2` column is the shape parameter $`\beta`$, constrained to be
equal across stress levels. The `$relationship` coefficients `coef1` and
`coef2` define the log-linear life-stress model (Nelson 1990).

## Plot Tools

The three `plot_*` tools run the full fitting pipeline and return an
interactive plot as a [plotly](https://plotly.com/r/) JSON string.
Claude Code (or any MCP client) can save the string to an `.html` file
that opens directly in a browser.

### The `plot_weibull` Tool

`plot_weibull` accepts the same arguments as `fit_weibull` plus an
optional `show_conf` flag, and returns the probability plot as a JSON
string.

``` r

ptool <- ReliaPlotR:::.make_plot_wblr_tool()
json_str <- ptool(failures = c(30, 49, 82, 90, 96))
nchar(json_str)  # plotly JSON string length
#> [1] 12759
```

### The `plot_alt` Tool

`plot_alt` accepts the same arguments as `fit_alt` and returns a named
list with two JSON strings: `probability_plot` (one fitted line per
stress level) and `life_stress_plot` (Arrhenius or Power Law
relationship).

``` r

ptool_alt <- ReliaPlotR:::.make_plot_alt_tool()
result_plots <- ptool_alt(
  stresses      = c(300, 350, 400),
  failures_json = "[[248,456,528,731,813,537],[164,176,289],[88,112,152]]",
  dist          = "weibull",
  alt_model     = "arrhenius"
)
```

``` r

nchar(result_plots$probability_plot)
#> [1] 74578
nchar(result_plots$life_stress_plot)
#> [1] 95564
```

### The `plot_rga` Tool

`plot_rga` fits a Crow-AMSAA model to failure count data and returns the
cumulative failure plot.

``` r

ptool_rga <- ReliaPlotR:::.make_plot_rga_tool()
json_rga <- ptool_rga(
  times    = c(100, 200, 300, 400, 500),
  failures = c(  2,   1,   3,   1,   2)
)
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
nchar(json_rga)
#> [1] 5240
```

## How the Tools Work

Each MCP tool wraps the same fitting pipeline used by the corresponding
`plotly_*` function:

    fit_weibull:    wblr() -> wblr.fit() -> wblr.conf() -> tidy_wblr()    -> named list
    fit_alt:     alt.make() -> alt.parallel() -> alt.fit() -> tidy_alt()  -> named list
    plot_weibull:   wblr() -> wblr.fit() -> wblr.conf() -> plotly_wblr()  -> plotly JSON
    plot_alt:    alt.make() -> alt.parallel() -> alt.fit() -> plotly_alt()
                                                           -> plotly_rel() -> plotly JSON × 2
    plot_rga:       rga()                                 -> plotly_rga()  -> plotly JSON

The accessor functions
([`tidy_wblr()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_wblr.md),
[`tidy_alt()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_alt.md),
[`tidy_rga()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_rga.md))
can also be called directly from R to extract parameter estimates from
already-fitted model objects without going through MCP.

## ReliaGrowR MCP Tools

The ReliaGrowR server exposes eight tools for reliability growth
analysis and repairable systems. Register it with
`claude mcp add -s user reliagrowR -- Rscript -e "ReliaGrowR::rga_mcp_server()"`.

| Tool | Arguments | Returns |
|----|----|----|
| `rga` | `times`, `failures`, `times_type`, `method` | λ, β, growth rate, log-likelihood, AIC, BIC |
| `nhpp` | `time`, `event`, `model_type`, `method` | model type, method, fitted parameters, GOF stats |
| `duane` | `times`, `failures`, `conf_level` | slope, intercept, GOF stats |
| `mcf` | `id`, `time`, `event`, `conf_level` | time points, MCF values, confidence bounds |
| `predict_rga` | `times`, `failures`, `forecast_times`, `method`, `conf_level` | forecast cumulative failures with bounds |
| `predict_duane` | `times`, `failures`, `forecast_times`, `conf_level` | forecast MTBF with bounds |
| `rdt` | `target`, `mission_time`, `conf_level`, `beta`, `f`, `n`, `test_time` | required sample size or test duration |
| `gof_rga` | `times`, `failures`, `method` | Cramér-von Mises (W²) and Kolmogorov-Smirnov (D) statistics |

## References

## See Also

- [Life Data
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/weibull.md)
  – fit Weibull/lognormal models interactively
- [Accelerated Life
  Testing](https://paulgovan.github.io/ReliaPlotR/articles/alt.md) –
  full ALT workflow with probability and life-stress plots
- [Reliability Growth
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/rga.md) –
  Crow-AMSAA and Duane models
- [Repairable Systems
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/repairable.md)
  – MCF and NHPP models

Nelson, Wayne B. 1990. *Accelerated Testing: Statistical Models, Test
Plans, and Data Analysis*. Wiley.
