# Launch a ReliaPlotR MCP Server.

Starts a Model Context Protocol (MCP) server that exposes five
reliability analysis tools to MCP clients such as Claude Code and Claude
Desktop.

## Usage

``` r
reliapltr_mcp_server(...)
```

## Arguments

- ...:

  Additional arguments passed to \[mcptools::mcp_server()\], such as
  \`type = "stdio"\` (default) or \`type = "http"\`.

## Value

Called for its side effect of launching a blocking MCP server process.

## Details

- \`fit_weibull\`:

  Fits a Weibull or lognormal distribution to time-to-failure data
  (optionally with right-censored suspensions) and returns parameter
  estimates and goodness-of-fit metrics.

- \`fit_alt\`:

  Fits an Accelerated Life Test (ALT) model across multiple stress
  levels and returns per-stress-level parameters and the global
  life-stress relationship coefficients.

- \`plot_weibull\`:

  Fits a Weibull or lognormal distribution and returns a Weibull
  probability plot as a plotly JSON string.

- \`plot_alt\`:

  Fits an ALT model and returns probability and life-stress relationship
  plots as plotly JSON strings.

- \`plot_rga\`:

  Fits a Crow-AMSAA reliability growth model and returns a cumulative
  failure plot as a plotly JSON string.

Both \`mcptools\` (\>= 0.2.0) and \`ellmer\` must be installed. They are
listed in \`Suggests\` and are not automatically installed with
ReliaPlotR. \`jsonlite\` is also required for the \`fit_alt\` tool.

\*\*Registering with Claude Code:\*\* “\`bash claude mcp add -s user
reliapltr – \\ Rscript -e "ReliaPlotR::reliapltr_mcp_server()" “\`

Alternatively, use the bundled launcher script: “\`bash claude mcp add
-s user reliapltr – \\ Rscript /path/to/ReliaPlotR/mcp/server.R “\`
