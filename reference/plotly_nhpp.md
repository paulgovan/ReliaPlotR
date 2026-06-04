# Interactive NHPP Plot.

The function creates an interactive Non-Homogeneous Poisson Process
(NHPP) plot for one or more \`nhpp\` objects. When a list of objects is
provided the models are overlaid on the same plot, each rendered in a
distinct color. The plot shows the nonparametric Mean Cumulative
Function (MCF) alongside the parametric model fit and optional
confidence bounds. Vertical lines indicate change points if breakpoints
are specified in the nhpp object.

## Usage

``` r
plotly_nhpp(
  nhpp_obj,
  showConf = TRUE,
  showGrid = TRUE,
  main = "NHPP Plot",
  xlab = "Cumulative Time",
  ylab = "Mean Cumulative Function",
  pointCol = "black",
  fitCol = "black",
  confCol = "black",
  gridCol = "lightgray",
  breakCol = "black",
  signif = 3,
  cols = NULL
)
```

## Arguments

- nhpp_obj:

  An object of class 'nhpp', or a list of such objects. Each object is
  created using the \`nhpp()\` function from the \`ReliaGrowR\` package.

- showConf:

  Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE.

- showGrid:

  Show grid (TRUE) or hide grid (FALSE). Default is TRUE.

- main:

  Main title. Default is "NHPP Plot".

- xlab:

  X-axis label. Default is "Cumulative Time".

- ylab:

  Y-axis label. Default is "Mean Cumulative Function".

- pointCol:

  Color of the MCF data points. Default is "black". Used only for a
  single nhpp object; ignored when \`cols\` is provided or multiple
  objects are supplied.

- fitCol:

  Color of the model fit. Default is "black". Used only for a single
  nhpp object; ignored when \`cols\` is provided or multiple objects are
  supplied.

- confCol:

  Color of the confidence bounds. Default is "black". Used only for a
  single nhpp object; ignored when \`cols\` is provided or multiple
  objects are supplied.

- gridCol:

  Color of the grid. Default is "lightgray".

- breakCol:

  Color of the breakpoints. Default is "black". Used only for a single
  nhpp object; ignored when \`cols\` is provided or multiple objects are
  supplied.

- signif:

  Significant digits of results. Default is 3. Must be a positive
  integer.

- cols:

  Optional character vector of colors, one per nhpp object. When
  provided, each object's points, fit line, confidence bounds, and
  breakpoints are all drawn in the corresponding color. Recycled if
  shorter than the number of objects.

## Value

A \`plotly\` object representing the interactive NHPP plot.

## Details

The nonparametric MCF is overlaid with the fitted parametric Power Law
NHPP model, \\E\[N(t)\] = \lambda t^\beta\\. Use this plot to assess
whether the parametric model fits the observed event history and to
identify change points. Confidence bounds are based on the Fisher matrix
approximation of the fitted parameters. For piecewise models, vertical
dotted lines mark each breakpoint.

## See also

\[plotly_mcf()\] for the nonparametric MCF alone; \[plotly_rga()\] for a
Crow-AMSAA cumulative-failures view.

## Examples

``` r
library(ReliaGrowR)
times <- c(100, 200, 300, 400, 500)
events <- c(1, 2, 1, 3, 2)
fit <- nhpp(time = times, event = events)
plotly_nhpp(fit)

{"x":{"visdat":{"1997b7603ed":["function () ","plotlyVisDat"]},"cur_data":"1997b7603ed","attrs":{"1997b7603ed":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":[100,200,300,400,500],"y":[1,3,4,7,9],"type":"scatter","mode":"markers","marker":{"color":"black"},"showlegend":false,"legendgroup":"1","name":"MCF","text":["MCF: (100, 1)","MCF: (200, 3)","MCF: (300, 4)","MCF: (400, 7)","MCF: (500, 9)"],"hoverinfo":"text","inherit":true},"1997b7603ed.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500],"y":[1.3079919108855118,2.9876905661606847,4.8437256861931575,6.8244266993076765,8.9033125270386577],"mode":"markers+lines","marker":{"color":"transparent"},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","name":"Fit","text":["Fit: (100, 1.308)","Fit: (200, 2.988)","Fit: (300, 4.844)","Fit: (400, 6.824)","Fit: (500, 8.903)"],"hoverinfo":"text","inherit":true},"1997b7603ed.2":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500],"y":[2.729121290920963,5.7006101109659717,9.095190615911191,12.902745216848462,17.096565051648124],"mode":"markers+lines","marker":{"color":"transparent"},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","text":["Upper: (100, 2.729)","Upper: (200, 5.701)","Upper: (300, 9.095)","Upper: (400, 12.903)","Upper: (500, 17.097)"],"hoverinfo":"text","inherit":true},"1997b7603ed.3":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500],"y":[0.62688413469692139,1.5658490486754213,2.5795697433810068,3.6095264218197927,4.636543873851541],"mode":"markers+lines","fill":"tonexty","fillcolor":"rgba(0,0,0,0.2)","marker":{"color":"transparent"},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","text":["Lower: (100, 0.627)","Lower: (200, 1.566)","Lower: (300, 2.58)","Lower: (400, 3.61)","Lower: (500, 4.637)"],"hoverinfo":"text","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"NHPP Plot","xaxis":{"domain":[0,1],"automargin":true,"title":"Cumulative Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Mean Cumulative Function","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[100,200,300,400,500],"y":[1,3,4,7,9],"type":"scatter","mode":"markers","marker":{"color":"black","line":{"color":"rgba(31,119,180,1)"}},"showlegend":false,"legendgroup":"1","name":"MCF","text":["MCF: (100, 1)","MCF: (200, 3)","MCF: (300, 4)","MCF: (400, 7)","MCF: (500, 9)"],"hoverinfo":["text","text","text","text","text"],"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[100,200,300,400,500],"y":[1.3079919108855118,2.9876905661606847,4.8437256861931575,6.8244266993076765,8.9033125270386577],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(255,127,14,1)"}},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","name":"Fit","text":["Fit: (100, 1.308)","Fit: (200, 2.988)","Fit: (300, 4.844)","Fit: (400, 6.824)","Fit: (500, 8.903)"],"hoverinfo":["text","text","text","text","text"],"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[100,200,300,400,500],"y":[2.729121290920963,5.7006101109659717,9.095190615911191,12.902745216848462,17.096565051648124],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(44,160,44,1)"}},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","text":["Upper: (100, 2.729)","Upper: (200, 5.701)","Upper: (300, 9.095)","Upper: (400, 12.903)","Upper: (500, 17.097)"],"hoverinfo":["text","text","text","text","text"],"error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(0,0,0,0.2)","type":"scatter","x":[100,200,300,400,500],"y":[0.62688413469692139,1.5658490486754213,2.5795697433810068,3.6095264218197927,4.636543873851541],"mode":"markers+lines","fill":"tonexty","marker":{"color":"transparent","line":{"color":"rgba(214,39,40,1)"}},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","text":["Lower: (100, 0.627)","Lower: (200, 1.566)","Lower: (300, 2.58)","Lower: (400, 3.61)","Lower: (500, 4.637)"],"hoverinfo":["text","text","text","text","text"],"name":"rgba(0,0,0,0.2)","error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
# Piecewise model with a breakpoint
times2 <- c(100, 200, 300, 400, 500, 600, 700, 800, 900, 1000)
events2 <- c(1, 2, 1, 1, 1, 2, 3, 1, 2, 4)
fit2 <- nhpp(time = times2, event = events2, breaks = 500, method = "LS")
plotly_nhpp(fit2, breakCol = "red")

{"x":{"visdat":{"1997172bb200":["function () ","plotlyVisDat"]},"cur_data":"1997172bb200","attrs":{"1997172bb200":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":[100,200,300,400,500,600,700,800,900,1000],"y":[1,3,4,5,6,8,11,12,14,18],"type":"scatter","mode":"markers","marker":{"color":"black"},"showlegend":false,"legendgroup":"1","name":"MCF","text":["MCF: (100, 1)","MCF: (200, 3)","MCF: (300, 4)","MCF: (400, 5)","MCF: (500, 6)","MCF: (600, 8)","MCF: (700, 11)","MCF: (800, 12)","MCF: (900, 14)","MCF: (1000, 18)"],"hoverinfo":"text","inherit":true},"1997172bb200.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[1.1411412230713962,2.4318656565895287,3.7858060913301164,5.1825054183759285,6.6118866006106876,8.1800104051641984,10.245028779674032,12.450768644863951,14.787400857867578,17.246835094559955],"mode":"markers+lines","marker":{"color":"transparent"},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","name":"Fit","text":["Fit: (100, 1.141)","Fit: (200, 2.432)","Fit: (300, 3.786)","Fit: (400, 5.183)","Fit: (500, 6.612)","Fit: (600, 8.18)","Fit: (700, 10.245)","Fit: (800, 12.451)","Fit: (900, 14.787)","Fit: (1000, 17.247)"],"hoverinfo":"text","inherit":true},"1997172bb200.2":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[1.4771941622021461,2.8122141303101742,4.3362926631781455,6.1125023308916946,8.0797890262058232,10.378402930381354,11.989030595184238,14.211674483297628,17.42307483149547,21.463355437088872],"mode":"markers+lines","marker":{"color":"transparent"},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","text":["Upper: (100, 1.477)","Upper: (200, 2.812)","Upper: (300, 4.336)","Upper: (400, 6.113)","Upper: (500, 8.08)","Upper: (600, 10.378)","Upper: (700, 11.989)","Upper: (800, 14.212)","Upper: (900, 17.423)","Upper: (1000, 21.463)"],"hoverinfo":"text","inherit":true},"1997172bb200.3":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[0.88153834093928862,2.1029588422725611,3.3052030557937013,4.3940044449157281,5.4106665752712342,6.4472896916265565,8.7547207310080459,10.908048874192664,12.550438211743248,13.858658850001751],"mode":"markers+lines","fill":"tonexty","fillcolor":"rgba(0,0,0,0.2)","marker":{"color":"transparent"},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","text":["Lower: (100, 0.882)","Lower: (200, 2.103)","Lower: (300, 3.305)","Lower: (400, 4.394)","Lower: (500, 5.411)","Lower: (600, 6.447)","Lower: (700, 8.755)","Lower: (800, 10.908)","Lower: (900, 12.55)","Lower: (1000, 13.859)"],"hoverinfo":"text","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"NHPP Plot","xaxis":{"domain":[0,1],"automargin":true,"title":"Cumulative Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Mean Cumulative Function","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"shapes":[{"type":"line","y0":0,"y1":1,"yref":"paper","x0":577.94854842955078,"x1":577.94854842955078,"line":{"color":"red","dash":"dot"}}],"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[100,200,300,400,500,600,700,800,900,1000],"y":[1,3,4,5,6,8,11,12,14,18],"type":"scatter","mode":"markers","marker":{"color":"black","line":{"color":"rgba(31,119,180,1)"}},"showlegend":false,"legendgroup":"1","name":"MCF","text":["MCF: (100, 1)","MCF: (200, 3)","MCF: (300, 4)","MCF: (400, 5)","MCF: (500, 6)","MCF: (600, 8)","MCF: (700, 11)","MCF: (800, 12)","MCF: (900, 14)","MCF: (1000, 18)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[1.1411412230713962,2.4318656565895287,3.7858060913301164,5.1825054183759285,6.6118866006106876,8.1800104051641984,10.245028779674032,12.450768644863951,14.787400857867578,17.246835094559955],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(255,127,14,1)"}},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","name":"Fit","text":["Fit: (100, 1.141)","Fit: (200, 2.432)","Fit: (300, 3.786)","Fit: (400, 5.183)","Fit: (500, 6.612)","Fit: (600, 8.18)","Fit: (700, 10.245)","Fit: (800, 12.451)","Fit: (900, 14.787)","Fit: (1000, 17.247)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[1.4771941622021461,2.8122141303101742,4.3362926631781455,6.1125023308916946,8.0797890262058232,10.378402930381354,11.989030595184238,14.211674483297628,17.42307483149547,21.463355437088872],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(44,160,44,1)"}},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","text":["Upper: (100, 1.477)","Upper: (200, 2.812)","Upper: (300, 4.336)","Upper: (400, 6.113)","Upper: (500, 8.08)","Upper: (600, 10.378)","Upper: (700, 11.989)","Upper: (800, 14.212)","Upper: (900, 17.423)","Upper: (1000, 21.463)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(0,0,0,0.2)","type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[0.88153834093928862,2.1029588422725611,3.3052030557937013,4.3940044449157281,5.4106665752712342,6.4472896916265565,8.7547207310080459,10.908048874192664,12.550438211743248,13.858658850001751],"mode":"markers+lines","fill":"tonexty","marker":{"color":"transparent","line":{"color":"rgba(214,39,40,1)"}},"line":{"color":"black"},"showlegend":false,"legendgroup":"1","text":["Lower: (100, 0.882)","Lower: (200, 2.103)","Lower: (300, 3.305)","Lower: (400, 4.394)","Lower: (500, 5.411)","Lower: (600, 6.447)","Lower: (700, 8.755)","Lower: (800, 10.908)","Lower: (900, 12.55)","Lower: (1000, 13.859)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"name":"rgba(0,0,0,0.2)","error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
# Overlay two models
plotly_nhpp(list(fit, fit2))

{"x":{"visdat":{"19973c1ab718":["function () ","plotlyVisDat"]},"cur_data":"19973c1ab718","attrs":{"19973c1ab718":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":[100,200,300,400,500],"y":[1,3,4,7,9],"type":"scatter","mode":"markers","marker":{"color":"#1f77b4"},"showlegend":true,"legendgroup":"1","name":"MCF 1","text":["MCF: (100, 1)","MCF: (200, 3)","MCF: (300, 4)","MCF: (400, 7)","MCF: (500, 9)"],"hoverinfo":"text","inherit":true},"19973c1ab718.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500],"y":[1.3079919108855118,2.9876905661606847,4.8437256861931575,6.8244266993076765,8.9033125270386577],"mode":"markers+lines","marker":{"color":"transparent"},"line":{"color":"#1f77b4"},"showlegend":true,"legendgroup":"1","name":"Fit 1","text":["Fit: (100, 1.308)","Fit: (200, 2.988)","Fit: (300, 4.844)","Fit: (400, 6.824)","Fit: (500, 8.903)"],"hoverinfo":"text","inherit":true},"19973c1ab718.2":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500],"y":[2.729121290920963,5.7006101109659717,9.095190615911191,12.902745216848462,17.096565051648124],"mode":"markers+lines","marker":{"color":"transparent"},"line":{"color":"#1f77b4"},"showlegend":false,"legendgroup":"1","text":["Upper: (100, 2.729)","Upper: (200, 5.701)","Upper: (300, 9.095)","Upper: (400, 12.903)","Upper: (500, 17.097)"],"hoverinfo":"text","inherit":true},"19973c1ab718.3":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500],"y":[0.62688413469692139,1.5658490486754213,2.5795697433810068,3.6095264218197927,4.636543873851541],"mode":"markers+lines","fill":"tonexty","fillcolor":"rgba(31,119,180,0.2)","marker":{"color":"transparent"},"line":{"color":"#1f77b4"},"showlegend":false,"legendgroup":"1","text":["Lower: (100, 0.627)","Lower: (200, 1.566)","Lower: (300, 2.58)","Lower: (400, 3.61)","Lower: (500, 4.637)"],"hoverinfo":"text","inherit":true},"19973c1ab718.4":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":[100,200,300,400,500,600,700,800,900,1000],"y":[1,3,4,5,6,8,11,12,14,18],"type":"scatter","mode":"markers","marker":{"color":"#ff7f0e"},"showlegend":true,"legendgroup":"2","name":"MCF 2","text":["MCF: (100, 1)","MCF: (200, 3)","MCF: (300, 4)","MCF: (400, 5)","MCF: (500, 6)","MCF: (600, 8)","MCF: (700, 11)","MCF: (800, 12)","MCF: (900, 14)","MCF: (1000, 18)"],"hoverinfo":"text","inherit":true},"19973c1ab718.5":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[1.1411412230713962,2.4318656565895287,3.7858060913301164,5.1825054183759285,6.6118866006106876,8.1800104051641984,10.245028779674032,12.450768644863951,14.787400857867578,17.246835094559955],"mode":"markers+lines","marker":{"color":"transparent"},"line":{"color":"#ff7f0e"},"showlegend":true,"legendgroup":"2","name":"Fit 2","text":["Fit: (100, 1.141)","Fit: (200, 2.432)","Fit: (300, 3.786)","Fit: (400, 5.183)","Fit: (500, 6.612)","Fit: (600, 8.18)","Fit: (700, 10.245)","Fit: (800, 12.451)","Fit: (900, 14.787)","Fit: (1000, 17.247)"],"hoverinfo":"text","inherit":true},"19973c1ab718.6":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[1.4771941622021461,2.8122141303101742,4.3362926631781455,6.1125023308916946,8.0797890262058232,10.378402930381354,11.989030595184238,14.211674483297628,17.42307483149547,21.463355437088872],"mode":"markers+lines","marker":{"color":"transparent"},"line":{"color":"#ff7f0e"},"showlegend":false,"legendgroup":"2","text":["Upper: (100, 1.477)","Upper: (200, 2.812)","Upper: (300, 4.336)","Upper: (400, 6.113)","Upper: (500, 8.08)","Upper: (600, 10.378)","Upper: (700, 11.989)","Upper: (800, 14.212)","Upper: (900, 17.423)","Upper: (1000, 21.463)"],"hoverinfo":"text","inherit":true},"19973c1ab718.7":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[0.88153834093928862,2.1029588422725611,3.3052030557937013,4.3940044449157281,5.4106665752712342,6.4472896916265565,8.7547207310080459,10.908048874192664,12.550438211743248,13.858658850001751],"mode":"markers+lines","fill":"tonexty","fillcolor":"rgba(255,127,14,0.2)","marker":{"color":"transparent"},"line":{"color":"#ff7f0e"},"showlegend":false,"legendgroup":"2","text":["Lower: (100, 0.882)","Lower: (200, 2.103)","Lower: (300, 3.305)","Lower: (400, 4.394)","Lower: (500, 5.411)","Lower: (600, 6.447)","Lower: (700, 8.755)","Lower: (800, 10.908)","Lower: (900, 12.55)","Lower: (1000, 13.859)"],"hoverinfo":"text","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"NHPP Plot","xaxis":{"domain":[0,1],"automargin":true,"title":"Cumulative Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Mean Cumulative Function","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"shapes":[{"type":"line","y0":0,"y1":1,"yref":"paper","x0":577.94854842955078,"x1":577.94854842955078,"line":{"color":"#ff7f0e","dash":"dot"}}],"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[100,200,300,400,500],"y":[1,3,4,7,9],"type":"scatter","mode":"markers","marker":{"color":"#1f77b4","line":{"color":"rgba(31,119,180,1)"}},"showlegend":true,"legendgroup":"1","name":"MCF 1","text":["MCF: (100, 1)","MCF: (200, 3)","MCF: (300, 4)","MCF: (400, 7)","MCF: (500, 9)"],"hoverinfo":["text","text","text","text","text"],"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[100,200,300,400,500],"y":[1.3079919108855118,2.9876905661606847,4.8437256861931575,6.8244266993076765,8.9033125270386577],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(255,127,14,1)"}},"line":{"color":"#1f77b4"},"showlegend":true,"legendgroup":"1","name":"Fit 1","text":["Fit: (100, 1.308)","Fit: (200, 2.988)","Fit: (300, 4.844)","Fit: (400, 6.824)","Fit: (500, 8.903)"],"hoverinfo":["text","text","text","text","text"],"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[100,200,300,400,500],"y":[2.729121290920963,5.7006101109659717,9.095190615911191,12.902745216848462,17.096565051648124],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(44,160,44,1)"}},"line":{"color":"#1f77b4"},"showlegend":false,"legendgroup":"1","text":["Upper: (100, 2.729)","Upper: (200, 5.701)","Upper: (300, 9.095)","Upper: (400, 12.903)","Upper: (500, 17.097)"],"hoverinfo":["text","text","text","text","text"],"error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(31,119,180,0.2)","type":"scatter","x":[100,200,300,400,500],"y":[0.62688413469692139,1.5658490486754213,2.5795697433810068,3.6095264218197927,4.636543873851541],"mode":"markers+lines","fill":"tonexty","marker":{"color":"transparent","line":{"color":"rgba(214,39,40,1)"}},"line":{"color":"#1f77b4"},"showlegend":false,"legendgroup":"1","text":["Lower: (100, 0.627)","Lower: (200, 1.566)","Lower: (300, 2.58)","Lower: (400, 3.61)","Lower: (500, 4.637)"],"hoverinfo":["text","text","text","text","text"],"name":"rgba(31,119,180,0.2)","error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[100,200,300,400,500,600,700,800,900,1000],"y":[1,3,4,5,6,8,11,12,14,18],"type":"scatter","mode":"markers","marker":{"color":"#ff7f0e","line":{"color":"rgba(148,103,189,1)"}},"showlegend":true,"legendgroup":"2","name":"MCF 2","text":["MCF: (100, 1)","MCF: (200, 3)","MCF: (300, 4)","MCF: (400, 5)","MCF: (500, 6)","MCF: (600, 8)","MCF: (700, 11)","MCF: (800, 12)","MCF: (900, 14)","MCF: (1000, 18)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"error_y":{"color":"rgba(148,103,189,1)"},"error_x":{"color":"rgba(148,103,189,1)"},"line":{"color":"rgba(148,103,189,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[1.1411412230713962,2.4318656565895287,3.7858060913301164,5.1825054183759285,6.6118866006106876,8.1800104051641984,10.245028779674032,12.450768644863951,14.787400857867578,17.246835094559955],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(140,86,75,1)"}},"line":{"color":"#ff7f0e"},"showlegend":true,"legendgroup":"2","name":"Fit 2","text":["Fit: (100, 1.141)","Fit: (200, 2.432)","Fit: (300, 3.786)","Fit: (400, 5.183)","Fit: (500, 6.612)","Fit: (600, 8.18)","Fit: (700, 10.245)","Fit: (800, 12.451)","Fit: (900, 14.787)","Fit: (1000, 17.247)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"error_y":{"color":"rgba(140,86,75,1)"},"error_x":{"color":"rgba(140,86,75,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[1.4771941622021461,2.8122141303101742,4.3362926631781455,6.1125023308916946,8.0797890262058232,10.378402930381354,11.989030595184238,14.211674483297628,17.42307483149547,21.463355437088872],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(227,119,194,1)"}},"line":{"color":"#ff7f0e"},"showlegend":false,"legendgroup":"2","text":["Upper: (100, 1.477)","Upper: (200, 2.812)","Upper: (300, 4.336)","Upper: (400, 6.113)","Upper: (500, 8.08)","Upper: (600, 10.378)","Upper: (700, 11.989)","Upper: (800, 14.212)","Upper: (900, 17.423)","Upper: (1000, 21.463)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"error_y":{"color":"rgba(227,119,194,1)"},"error_x":{"color":"rgba(227,119,194,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(255,127,14,0.2)","type":"scatter","x":[100,200,300,400,500,600,700,800,900,1000],"y":[0.88153834093928862,2.1029588422725611,3.3052030557937013,4.3940044449157281,5.4106665752712342,6.4472896916265565,8.7547207310080459,10.908048874192664,12.550438211743248,13.858658850001751],"mode":"markers+lines","fill":"tonexty","marker":{"color":"transparent","line":{"color":"rgba(127,127,127,1)"}},"line":{"color":"#ff7f0e"},"showlegend":false,"legendgroup":"2","text":["Lower: (100, 0.882)","Lower: (200, 2.103)","Lower: (300, 3.305)","Lower: (400, 4.394)","Lower: (500, 5.411)","Lower: (600, 6.447)","Lower: (700, 8.755)","Lower: (800, 10.908)","Lower: (900, 12.55)","Lower: (1000, 13.859)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"name":"rgba(255,127,14,0.2)","error_y":{"color":"rgba(127,127,127,1)"},"error_x":{"color":"rgba(127,127,127,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
