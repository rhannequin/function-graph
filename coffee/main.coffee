# Print axes
lauch = ->
  canvas = document.getElementById 'canvas'

  axes.x0 = .5 + .5 * canvas.width  # x0 pixels from left to x=0
  axes.y0 = .5 + .5 * canvas.height # y0 pixels from top to y=0
  axes.scale = 20
  axes.doNegativeX = yes

  # Show axes
  x0   = axes.x0
  w    = ctx.canvas.width
  y0   = axes.y0
  h    = ctx.canvas.height
  xmin = if axes.doNegativeX then 0 else x0
  ctx.beginPath()
  ctx.strokeStyle = 'rgb(128,128,128)'
  # X axis
  ctx.moveTo xmin, y0
  ctx.lineTo w, y0
  # Y axis
  ctx.moveTo x0, 0
  ctx.lineTo x0, h
  ctx.stroke()

if typeof canvas isnt 'undefined' and typeof canvas.getContext isnt 'undefined'
  axes = {}
  ctx  = canvas.getContext '2d'
  lauch()

# Function to create graphs
funGraph = (func, i) ->
  str = '<canvas class="graph" id="canvas' + i + '" width="1000" height="500"></canvas>'
  $('.canvas-box').append str

  cv = document.getElementById 'canvas' + i
  context = cv.getContext '2d'

  color = 'rgb(66,44,255)'
  thick = 1

  dx    = 4
  x0    = axes.x0
  y0    = axes.y0
  scale = axes.scale
  iMax  = Math.round (context.canvas.width - x0) / dx
  iMin  = if axes.doNegativeX then Math.round(-x0 / dx) else 0
  context.beginPath()
  context.lineWidth = thick
  context.strokeStyle = color

  i = iMin
  loop
    xx = dx * i;
    yy = scale * func(xx / scale)
    if i is iMin then context.moveTo(x0 + xx, y0 - yy) else context.lineTo(x0 + xx, y0 - yy)
    i = i + 0.1
    break if i > iMax

  context.stroke()


clearFunction = (number) ->
  $('#canvas' + number).remove();

i = 0

# Default printed function
func = (x) -> Math.log(x)
funGraph func, i++

$('input:submit').click ->
  val = $('input[type="text"]').val()
  func = (x) ->
    eval val
  funGraph func, i++