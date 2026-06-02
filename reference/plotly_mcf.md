# Interactive Mean Cumulative Function Plot.

The function creates an interactive Mean Cumulative Function (MCF) plot
for one or more \`mcf\` objects. When a list of objects is provided the
models are overlaid on the same plot, each rendered in a distinct color.
The MCF is rendered as a step function. Optional confidence bounds are
shown as a shaded band around the estimate.

## Usage

``` r
plotly_mcf(
  mcf_obj,
  showConf = TRUE,
  showGrid = TRUE,
  main = "Mean Cumulative Function Plot",
  xlab = "Time",
  ylab = "Mean Cumulative Function",
  fitCol = "black",
  confCol = "black",
  gridCol = "lightgray",
  signif = 3,
  cols = NULL
)
```

## Arguments

- mcf_obj:

  An object of class 'mcf', or a list of such objects. Each object is
  created using the \`mcf()\` function from the \`ReliaGrowR\` package.

- showConf:

  Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE.

- showGrid:

  Show grid (TRUE) or hide grid (FALSE). Default is TRUE.

- main:

  Main title. Default is "Mean Cumulative Function Plot".

- xlab:

  X-axis label. Default is "Time".

- ylab:

  Y-axis label. Default is "Mean Cumulative Function".

- fitCol:

  Color of the MCF step function. Default is "black". Used only for a
  single mcf object; ignored when \`cols\` is provided or multiple
  objects are supplied.

- confCol:

  Color of the confidence bounds. Default is "black". Used only for a
  single mcf object; ignored when \`cols\` is provided or multiple
  objects are supplied.

- gridCol:

  Color of the grid. Default is "lightgray".

- signif:

  Significant digits of results. Default is 3. Must be a positive
  integer.

- cols:

  Optional character vector of colors, one per mcf object. When
  provided, each object's step function and confidence bounds are drawn
  in the corresponding color. Recycled if shorter than the number of
  objects.

## Value

A \`plotly\` object representing the interactive MCF plot.

## Details

The MCF is a nonparametric estimate of the expected cumulative number of
events per system by time \\t\\. It is computed from recurrence data
(multiple events per system) and rendered as a step function. The slope
of the MCF at any point approximates the current event rate (repairs per
unit time). Confidence bounds are computed using the Nelson variance
estimator.

## See also

\[plotly_nhpp()\] to overlay a parametric Power Law model on the MCF;
\[plotly_exposure()\] for the cumulative event rate.

## Examples

``` r
library(ReliaGrowR)
ids <- c("A", "A", "A", "B", "B", "C", "C", "C", "C")
times <- c(50, 150, 350, 100, 300, 80, 200, 320, 450)
fit <- mcf(id = ids, time = times)
plotly_mcf(fit)

{"x":{"visdat":{"1a5725ddbc2b":["function () ","plotlyVisDat"]},"cur_data":"1a5725ddbc2b","attrs":{"1a5725ddbc2b":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.33333333333333331,0.66666666666666663,1,1.3333333333333333,1.6666666666666665,2,2.5,3,4],"mode":"lines","line":{"color":"black","shape":"hv"},"showlegend":false,"legendgroup":"1","name":"MCF","text":["MCF: (50, 0.333)","MCF: (80, 0.667)","MCF: (100, 1)","MCF: (150, 1.333)","MCF: (200, 1.667)","MCF: (300, 2)","MCF: (320, 2.5)","MCF: (350, 3)","MCF: (450, 4)"],"hoverinfo":"text","inherit":true},"1a5725ddbc2b.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0,0,0,0.026690676973297522,0.20579576570569769,0.39969610788156373,0.62347735097522827,0.88299693966294024,1.1150111303211929],"mode":"lines","line":{"color":"black","shape":"hv"},"showlegend":false,"legendgroup":"1","text":["Lower: (50, 0)","Lower: (80, 0)","Lower: (100, 0)","Lower: (150, 0.027)","Lower: (200, 0.206)","Lower: (300, 0.4)","Lower: (320, 0.623)","Lower: (350, 0.883)","Lower: (450, 1.115)"],"hoverinfo":"text","inherit":true},"1a5725ddbc2b.2":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.98665466151335113,1.5906025495664515,2.1315857340761717,2.6399759896933688,3.1275375676276354,3.6003038921184363,4.3765226490247713,5.1170030603370602,6.8849888696788071],"mode":"lines","fill":"tonexty","fillcolor":"rgba(0,0,0,0.2)","line":{"color":"black","shape":"hv"},"showlegend":false,"legendgroup":"1","text":["Upper: (50, 0.987)","Upper: (80, 1.591)","Upper: (100, 2.132)","Upper: (150, 2.64)","Upper: (200, 3.128)","Upper: (300, 3.6)","Upper: (320, 4.377)","Upper: (350, 5.117)","Upper: (450, 6.885)"],"hoverinfo":"text","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"Mean Cumulative Function Plot","xaxis":{"domain":[0,1],"automargin":true,"title":"Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Mean Cumulative Function","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.33333333333333331,0.66666666666666663,1,1.3333333333333333,1.6666666666666665,2,2.5,3,4],"mode":"lines","line":{"color":"black","shape":"hv"},"showlegend":false,"legendgroup":"1","name":"MCF","text":["MCF: (50, 0.333)","MCF: (80, 0.667)","MCF: (100, 1)","MCF: (150, 1.333)","MCF: (200, 1.667)","MCF: (300, 2)","MCF: (320, 2.5)","MCF: (350, 3)","MCF: (450, 4)"],"hoverinfo":["text","text","text","text","text","text","text","text","text"],"marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0,0,0,0.026690676973297522,0.20579576570569769,0.39969610788156373,0.62347735097522827,0.88299693966294024,1.1150111303211929],"mode":"lines","line":{"color":"black","shape":"hv"},"showlegend":false,"legendgroup":"1","text":["Lower: (50, 0)","Lower: (80, 0)","Lower: (100, 0)","Lower: (150, 0.027)","Lower: (200, 0.206)","Lower: (300, 0.4)","Lower: (320, 0.623)","Lower: (350, 0.883)","Lower: (450, 1.115)"],"hoverinfo":["text","text","text","text","text","text","text","text","text"],"marker":{"color":"rgba(255,127,14,1)","line":{"color":"rgba(255,127,14,1)"}},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(0,0,0,0.2)","type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.98665466151335113,1.5906025495664515,2.1315857340761717,2.6399759896933688,3.1275375676276354,3.6003038921184363,4.3765226490247713,5.1170030603370602,6.8849888696788071],"mode":"lines","fill":"tonexty","line":{"color":"black","shape":"hv"},"showlegend":false,"legendgroup":"1","text":["Upper: (50, 0.987)","Upper: (80, 1.591)","Upper: (100, 2.132)","Upper: (150, 2.64)","Upper: (200, 3.128)","Upper: (300, 3.6)","Upper: (320, 4.377)","Upper: (350, 5.117)","Upper: (450, 6.885)"],"hoverinfo":["text","text","text","text","text","text","text","text","text"],"name":"rgba(0,0,0,0.2)","marker":{"color":"rgba(44,160,44,1)","line":{"color":"rgba(44,160,44,1)"}},"error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
# Overlay two MCF objects
fit2 <- mcf(id = c("X", "X", "Y"), time = c(60, 220, 180))
plotly_mcf(list(fit, fit2), cols = c("steelblue", "tomato"))

{"x":{"visdat":{"1a577aee892c":["function () ","plotlyVisDat"]},"cur_data":"1a577aee892c","attrs":{"1a577aee892c":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.33333333333333331,0.66666666666666663,1,1.3333333333333333,1.6666666666666665,2,2.5,3,4],"mode":"lines","line":{"color":"steelblue","shape":"hv"},"showlegend":true,"legendgroup":"1","name":"MCF 1","text":["MCF: (50, 0.333)","MCF: (80, 0.667)","MCF: (100, 1)","MCF: (150, 1.333)","MCF: (200, 1.667)","MCF: (300, 2)","MCF: (320, 2.5)","MCF: (350, 3)","MCF: (450, 4)"],"hoverinfo":"text","inherit":true},"1a577aee892c.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0,0,0,0.026690676973297522,0.20579576570569769,0.39969610788156373,0.62347735097522827,0.88299693966294024,1.1150111303211929],"mode":"lines","line":{"color":"steelblue","shape":"hv"},"showlegend":false,"legendgroup":"1","text":["Lower: (50, 0)","Lower: (80, 0)","Lower: (100, 0)","Lower: (150, 0.027)","Lower: (200, 0.206)","Lower: (300, 0.4)","Lower: (320, 0.623)","Lower: (350, 0.883)","Lower: (450, 1.115)"],"hoverinfo":"text","inherit":true},"1a577aee892c.2":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.98665466151335113,1.5906025495664515,2.1315857340761717,2.6399759896933688,3.1275375676276354,3.6003038921184363,4.3765226490247713,5.1170030603370602,6.8849888696788071],"mode":"lines","fill":"tonexty","fillcolor":"rgba(70,130,180,0.2)","line":{"color":"steelblue","shape":"hv"},"showlegend":false,"legendgroup":"1","text":["Upper: (50, 0.987)","Upper: (80, 1.591)","Upper: (100, 2.132)","Upper: (150, 2.64)","Upper: (200, 3.128)","Upper: (300, 3.6)","Upper: (320, 4.377)","Upper: (350, 5.117)","Upper: (450, 6.885)"],"hoverinfo":"text","inherit":true},"1a577aee892c.3":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[60,180,220],"y":[0.5,1,2],"mode":"lines","line":{"color":"tomato","shape":"hv"},"showlegend":true,"legendgroup":"2","name":"MCF 2","text":["MCF: (60, 0.5)","MCF: (180, 1)","MCF: (220, 2)"],"hoverinfo":"text","inherit":true},"1a577aee892c.4":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[60,180,220],"y":[0,0,0],"mode":"lines","line":{"color":"tomato","shape":"hv"},"showlegend":false,"legendgroup":"2","text":["Lower: (60, 0)","Lower: (180, 0)","Lower: (220, 0)"],"hoverinfo":"text","inherit":true},"1a577aee892c.5":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[60,180,220],"y":[1.4799819922700268,2.3859038243496773,4.4004558381776544],"mode":"lines","fill":"tonexty","fillcolor":"rgba(255,99,71,0.2)","line":{"color":"tomato","shape":"hv"},"showlegend":false,"legendgroup":"2","text":["Upper: (60, 1.48)","Upper: (180, 2.386)","Upper: (220, 4.4)"],"hoverinfo":"text","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"Mean Cumulative Function Plot","xaxis":{"domain":[0,1],"automargin":true,"title":"Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Mean Cumulative Function","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.33333333333333331,0.66666666666666663,1,1.3333333333333333,1.6666666666666665,2,2.5,3,4],"mode":"lines","line":{"color":"steelblue","shape":"hv"},"showlegend":true,"legendgroup":"1","name":"MCF 1","text":["MCF: (50, 0.333)","MCF: (80, 0.667)","MCF: (100, 1)","MCF: (150, 1.333)","MCF: (200, 1.667)","MCF: (300, 2)","MCF: (320, 2.5)","MCF: (350, 3)","MCF: (450, 4)"],"hoverinfo":["text","text","text","text","text","text","text","text","text"],"marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0,0,0,0.026690676973297522,0.20579576570569769,0.39969610788156373,0.62347735097522827,0.88299693966294024,1.1150111303211929],"mode":"lines","line":{"color":"steelblue","shape":"hv"},"showlegend":false,"legendgroup":"1","text":["Lower: (50, 0)","Lower: (80, 0)","Lower: (100, 0)","Lower: (150, 0.027)","Lower: (200, 0.206)","Lower: (300, 0.4)","Lower: (320, 0.623)","Lower: (350, 0.883)","Lower: (450, 1.115)"],"hoverinfo":["text","text","text","text","text","text","text","text","text"],"marker":{"color":"rgba(255,127,14,1)","line":{"color":"rgba(255,127,14,1)"}},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(70,130,180,0.2)","type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.98665466151335113,1.5906025495664515,2.1315857340761717,2.6399759896933688,3.1275375676276354,3.6003038921184363,4.3765226490247713,5.1170030603370602,6.8849888696788071],"mode":"lines","fill":"tonexty","line":{"color":"steelblue","shape":"hv"},"showlegend":false,"legendgroup":"1","text":["Upper: (50, 0.987)","Upper: (80, 1.591)","Upper: (100, 2.132)","Upper: (150, 2.64)","Upper: (200, 3.128)","Upper: (300, 3.6)","Upper: (320, 4.377)","Upper: (350, 5.117)","Upper: (450, 6.885)"],"hoverinfo":["text","text","text","text","text","text","text","text","text"],"name":"rgba(70,130,180,0.2)","marker":{"color":"rgba(44,160,44,1)","line":{"color":"rgba(44,160,44,1)"}},"error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[60,180,220],"y":[0.5,1,2],"mode":"lines","line":{"color":"tomato","shape":"hv"},"showlegend":true,"legendgroup":"2","name":"MCF 2","text":["MCF: (60, 0.5)","MCF: (180, 1)","MCF: (220, 2)"],"hoverinfo":["text","text","text"],"marker":{"color":"rgba(214,39,40,1)","line":{"color":"rgba(214,39,40,1)"}},"error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[60,180,220],"y":[0,0,0],"mode":"lines","line":{"color":"tomato","shape":"hv"},"showlegend":false,"legendgroup":"2","text":["Lower: (60, 0)","Lower: (180, 0)","Lower: (220, 0)"],"hoverinfo":["text","text","text"],"marker":{"color":"rgba(148,103,189,1)","line":{"color":"rgba(148,103,189,1)"}},"error_y":{"color":"rgba(148,103,189,1)"},"error_x":{"color":"rgba(148,103,189,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(255,99,71,0.2)","type":"scatter","x":[60,180,220],"y":[1.4799819922700268,2.3859038243496773,4.4004558381776544],"mode":"lines","fill":"tonexty","line":{"color":"tomato","shape":"hv"},"showlegend":false,"legendgroup":"2","text":["Upper: (60, 1.48)","Upper: (180, 2.386)","Upper: (220, 4.4)"],"hoverinfo":["text","text","text"],"name":"rgba(255,99,71,0.2)","marker":{"color":"rgba(140,86,75,1)","line":{"color":"rgba(140,86,75,1)"}},"error_y":{"color":"rgba(140,86,75,1)"},"error_x":{"color":"rgba(140,86,75,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
