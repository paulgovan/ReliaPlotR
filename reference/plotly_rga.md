# Interactive Reliability Growth Plot.

The function creates an interactive reliability growth plot for an
\`rga\` object. The plot includes cumulative failures over time, the
model fit, and optional confidence bounds. Vertical lines indicate
change points if breakpoints are specified in the rga object.

## Usage

``` r
plotly_rga(
  rga_obj,
  showConf = TRUE,
  showGrid = TRUE,
  main = "Reliability Growth Plot",
  xlab = "Cumulative Time",
  ylab = "Cumulative Failures",
  pointCol = "black",
  fitCol = "black",
  confCol = "black",
  gridCol = "lightgray",
  breakCol = "black"
)
```

## Arguments

- rga_obj:

  An object of class 'rga'. This object is created using the \`rga()\`
  function from the \`ReliaGrowR\` package.

- showConf:

  Show the confidence bounds (TRUE) or not (FALSE).

- showGrid:

  Show grid (TRUE) or hide grid (FALSE).

- main:

  Main title.

- xlab:

  X-axis label.

- ylab:

  Y-axis label.

- pointCol:

  Color of the point values.

- fitCol:

  Color of the model fit.

- confCol:

  Color of the confidence bounds.

- gridCol:

  Color of the grid.

- breakCol:

  Color of the breakpoints.

## Value

The function returns no value. It generates an interactive plotly plot.

## Examples

``` r
library(ReliaGrowR)
times <- c(100, 200, 300, 400, 500)
failures <- c(1, 2, 1, 3, 2)
rga <- rga(times, failures)
plotly_rga(rga)

{"x":{"visdat":{"1bde17263f7b":["function () ","plotlyVisDat"]},"cur_data":"1bde17263f7b","attrs":{"1bde17263f7b":{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500],"y":[1,3.0000000000000004,4,6.9999999999999991,9.0000000000000018],"mode":"markers","marker":{"color":"black"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"},"1bde17263f7b.1":{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500],"y":[1.0656020008215583,2.5624780382779875,4.457439704028455,6.7030223861429965,9.266387751664956],"mode":"markers+lines","marker":{"color":"transparent"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","line":{"color":"black"},"inherit":true},"1bde17263f7b.2":{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500],"y":[0.76567421185484486,2.1157686909742321,3.7410494062962871,5.4093372257587626,7.1120671357535361],"mode":"markers+lines","marker":{"color":"transparent"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","line":{"color":"black"},"inherit":true},"1bde17263f7b.3":{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500],"y":[1.483016675465852,3.1035026298803357,5.3110147868161288,8.3061024362059044,12.073274945977946],"mode":"markers+lines","marker":{"color":"transparent"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","fill":"tonexty","fillcolor":"rgba(0,0,0,0.2)","line":{"color":"black"},"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"Reliability Growth Plot","xaxis":{"domain":[0,1],"automargin":true,"title":"Cumulative Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Cumulative Failures","showline":true,"mirror":"ticks","size":["function (x, ...) ","UseMethod(\"text\")"],"showgrid":true,"gridcolor":"lightgray"},"shapes":[{"type":"line","y0":0,"y1":1,"yref":"paper","x0":[],"x1":[],"line":{"color":"black","dash":"dot"}}],"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500],"y":[1,3.0000000000000004,4,6.9999999999999991,9.0000000000000018],"mode":"markers","marker":{"color":"black","line":{"color":"rgba(31,119,180,1)"}},"showlegend":false,"text":["Failures: (100, 1)","Failures: (300, 3)","Failures: (600, 4)","Failures: (1000, 7)","Failures: (1500, 9)"],"hoverinfo":["text","text","text","text","text"],"name":"","type":"scatter","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500],"y":[1.0656020008215583,2.5624780382779875,4.457439704028455,6.7030223861429965,9.266387751664956],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(255,127,14,1)"}},"showlegend":false,"text":["Fit: 100, 1.06560200082156)","Fit: 300, 2.56247803827799)","Fit: 600, 4.45743970402846)","Fit: 1000, 6.703022386143)","Fit: 1500, 9.26638775166496)"],"hoverinfo":["text","text","text","text","text"],"name":"","type":"scatter","line":{"color":"black"},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500],"y":[0.76567421185484486,2.1157686909742321,3.7410494062962871,5.4093372257587626,7.1120671357535361],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(44,160,44,1)"}},"showlegend":false,"text":["Lower: 100, 0.765674211854845)","Lower: 300, 2.11576869097423)","Lower: 600, 3.74104940629629)","Lower: 1000, 5.40933722575876)","Lower: 1500, 7.11206713575354)"],"hoverinfo":["text","text","text","text","text"],"name":"","type":"scatter","line":{"color":"black"},"error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(0,0,0,0.2)","x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500],"y":[1.483016675465852,3.1035026298803357,5.3110147868161288,8.3061024362059044,12.073274945977946],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(214,39,40,1)"}},"showlegend":false,"text":["Upper: 100, 1.48301667546585)","Upper: 300, 3.10350262988034)","Upper: 600, 5.31101478681613)","Upper: 1000, 8.3061024362059)","Upper: 1500, 12.0732749459779)"],"hoverinfo":["text","text","text","text","text"],"name":"","type":"scatter","fill":"tonexty","line":{"color":"black"},"error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
times <- c(100, 200, 300, 400, 500, 600, 700, 800, 900, 1000)
failures <- c(1, 2, 1, 1, 1, 2, 3, 1, 2, 4)
breakpoints <- 400
rga2 <- rga(times, failures, model_type = "Piecewise NHPP", breaks = breakpoints)
#> Warning: Breakpoint estimate(s) outdistanced to allow finite estimates and st.errs
plotly_rga(rga2, fitCol = "blue", confCol = "blue", breakCol = "red")

{"x":{"visdat":{"1bde73a043d3":["function () ","plotlyVisDat"]},"cur_data":"1bde73a043d3","attrs":{"1bde73a043d3":{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500,2100,2799.9999999999995,3599.9999999999982,4500.0000000000009,5499.9999999999991],"y":[1,3.0000000000000004,4,4.9999999999999991,6,7.9999999999999982,11.000000000000002,12,13.999999999999996,17.999999999999996],"mode":"markers","marker":{"color":"black"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"},"1bde73a043d3.1":{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500,2100,2799.9999999999995,3599.9999999999982,4500.0000000000009,5499.9999999999991],"y":[1.0000127470946398,2.6079364750018557,4.0015161402218,5.4857831033423041,7.0468140211452166,8.6744443186135385,10.361055031213324,12.100734671265576,13.888760251444074,15.721266742816749],"mode":"markers+lines","marker":{"color":"transparent"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","line":{"color":"blue"},"inherit":true},"1bde73a043d3.2":{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500,2100,2799.9999999999995,3599.9999999999982,4500.0000000000009,5499.9999999999991],"y":[0.75036625430945014,1.9568825796566922,3.2503662272376852,4.7263950028366217,6.2882446012996693,7.8362730744451934,9.3001280093897911,10.681511765041598,12.009091038714679,13.303927419093121],"mode":"markers+lines","marker":{"color":"transparent"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","line":{"color":"blue"},"inherit":true},"1bde73a043d3.3":{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500,2100,2799.9999999999995,3599.9999999999982,4500.0000000000009,5499.9999999999991],"y":[1.3327165082497952,3.4755956889545736,4.9262545513412617,6.367181803225213,7.8968918986302592,9.6022667308660772,11.543009004977618,13.708525797218794,16.06263627282307,18.577839476490755],"mode":"markers+lines","marker":{"color":"transparent"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","fill":"tonexty","fillcolor":"rgba(0,0,255,0.2)","line":{"color":"blue"},"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"Reliability Growth Plot","xaxis":{"domain":[0,1],"automargin":true,"title":"Cumulative Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Cumulative Failures","showline":true,"mirror":"ticks","size":["function (x, ...) ","UseMethod(\"text\")"],"showgrid":true,"gridcolor":"lightgray"},"shapes":[{"type":"line","y0":0,"y1":1,"yref":"paper","x0":399.99999999999989,"x1":399.99999999999989,"line":{"color":"red","dash":"dot"}}],"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500,2100,2799.9999999999995,3599.9999999999982,4500.0000000000009,5499.9999999999991],"y":[1,3.0000000000000004,4,4.9999999999999991,6,7.9999999999999982,11.000000000000002,12,13.999999999999996,17.999999999999996],"mode":"markers","marker":{"color":"black","line":{"color":"rgba(31,119,180,1)"}},"showlegend":false,"text":["Failures: (100, 1)","Failures: (300, 3)","Failures: (600, 4)","Failures: (1000, 5)","Failures: (1500, 6)","Failures: (2100, 8)","Failures: (2800, 11)","Failures: (3600, 12)","Failures: (4500, 14)","Failures: (5500, 18)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"name":"","type":"scatter","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500,2100,2799.9999999999995,3599.9999999999982,4500.0000000000009,5499.9999999999991],"y":[1.0000127470946398,2.6079364750018557,4.0015161402218,5.4857831033423041,7.0468140211452166,8.6744443186135385,10.361055031213324,12.100734671265576,13.888760251444074,15.721266742816749],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(255,127,14,1)"}},"showlegend":false,"text":["Fit: 100, 1.00001274709464)","Fit: 300, 2.60793647500186)","Fit: 600, 4.0015161402218)","Fit: 1000, 5.4857831033423)","Fit: 1500, 7.04681402114522)","Fit: 2100, 8.67444431861354)","Fit: 2800, 10.3610550312133)","Fit: 3600, 12.1007346712656)","Fit: 4500, 13.8887602514441)","Fit: 5500, 15.7212667428167)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"name":"","type":"scatter","line":{"color":"blue"},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500,2100,2799.9999999999995,3599.9999999999982,4500.0000000000009,5499.9999999999991],"y":[0.75036625430945014,1.9568825796566922,3.2503662272376852,4.7263950028366217,6.2882446012996693,7.8362730744451934,9.3001280093897911,10.681511765041598,12.009091038714679,13.303927419093121],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(44,160,44,1)"}},"showlegend":false,"text":["Lower: 100, 0.75036625430945)","Lower: 300, 1.95688257965669)","Lower: 600, 3.25036622723769)","Lower: 1000, 4.72639500283662)","Lower: 1500, 6.28824460129967)","Lower: 2100, 7.83627307444519)","Lower: 2800, 9.30012800938979)","Lower: 3600, 10.6815117650416)","Lower: 4500, 12.0090910387147)","Lower: 5500, 13.3039274190931)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"name":"","type":"scatter","line":{"color":"blue"},"error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(0,0,255,0.2)","x":[100.00000000000004,299.99999999999994,600,999.99999999999977,1500,2100,2799.9999999999995,3599.9999999999982,4500.0000000000009,5499.9999999999991],"y":[1.3327165082497952,3.4755956889545736,4.9262545513412617,6.367181803225213,7.8968918986302592,9.6022667308660772,11.543009004977618,13.708525797218794,16.06263627282307,18.577839476490755],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(214,39,40,1)"}},"showlegend":false,"text":["Upper: 100, 1.3327165082498)","Upper: 300, 3.47559568895457)","Upper: 600, 4.92625455134126)","Upper: 1000, 6.36718180322521)","Upper: 1500, 7.89689189863026)","Upper: 2100, 9.60226673086608)","Upper: 2800, 11.5430090049776)","Upper: 3600, 13.7085257972188)","Upper: 4500, 16.0626362728231)","Upper: 5500, 18.5778394764908)"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text"],"name":"","type":"scatter","fill":"tonexty","line":{"color":"blue"},"error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
