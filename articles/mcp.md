# MCP Tools

``` r

library(ReliaPlotR)
```

## Overview

The [Model Context Protocol](https://modelcontextprotocol.io) (MCP) is
an open standard that lets AI assistants call external tools as part of
a conversation.
[`reliapltr_mcp_server()`](https://paulgovan.github.io/ReliaPlotR/reference/reliapltr_mcp_server.md)
launches a lightweight MCP server that exposes two reliability analysis
tools to any MCP client, such as [Claude Code](https://claude.ai/code)
or Claude Desktop:

| Tool | What it does |
|----|----|
| `fit_weibull` | Fit a Weibull or lognormal distribution to time-to-failure data and return parameter estimates |
| `fit_alt` | Fit an Accelerated Life Test (ALT) model across multiple stress levels and return life-stress relationship coefficients |

These tools complement the reliability growth tools (`rga`, `nhpp`,
`duane`, `mcf`) already provided by the `ReliaGrowR` package’s own MCP
server.

## Installation

`mcptools` and `ellmer` are optional dependencies listed in `Suggests`.
Install them before starting the server:

``` r

pak::pak(c("mcptools", "ellmer"))
```

## Registering with Claude Code

Once the packages are installed, register the server in your Claude Code
session. Two equivalent approaches are available:

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

Confirm the server is registered:

``` bash
claude mcp list
```

Once registered, Claude Code will offer the `fit_weibull` and `fit_alt`
tools automatically whenever it detects a reliability analysis task.

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

## How the Tools Work

Each MCP tool wraps the same fitting pipeline used by the corresponding
`plotly_*` function, then formats results using the
[`tidy_wblr()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_wblr.md)
and
[`tidy_alt()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_alt.md)
accessor functions:

    fit_weibull:   wblr() -> wblr.fit() -> wblr.conf() -> tidy_wblr() -> named list
    fit_alt:    alt.make() -> alt.parallel() -> alt.fit() -> tidy_alt() -> named list

The accessor functions
([`tidy_wblr()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_wblr.md),
[`tidy_alt()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_alt.md),
[`tidy_rga()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_rga.md))
can also be called directly from R to extract parameter estimates from
already-fitted model objects without going through MCP.

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
