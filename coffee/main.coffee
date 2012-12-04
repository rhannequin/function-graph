# Backbone

Graph = Backbone.Model.extend
  initialize: ->
  default: {}

GraphCollection = Backbone.Collection.extend
  model : Graph

AppView = Backbone.View.extend
  el: 'body'
  events:
    'submit form': 'addGraph'
  cpt: 0

  initialize: ->
    canvas = document.getElementById 'canvas'
    ctx  = canvas.getContext '2d'
    @axes =
      x0: .5 + .5 * canvas.width  # x0 pixels from left to x=0
      y0: .5 + .5 * canvas.height # y0 pixels from top to y=0
      scale: 20
      doNegativeX: yes

    # Show axes
    x0   = @axes.x0
    y0   = @axes.y0
    xmin = if @axes.doNegativeX then 0 else x0

    ctx.beginPath()
    ctx.strokeStyle = 'rgb(128,128,128)'
    ctx.moveTo xmin, y0
    ctx.lineTo ctx.canvas.width, y0
    ctx.moveTo x0, 0
    ctx.lineTo x0, ctx.canvas.height
    ctx.stroke()

    # Draw sample graph
    sample = (x) -> Math.log(x)
    @drawGraph sample


  addGraph: (e) ->
    e.preventDefault()
    form = $(e.target)
    val = form.find('input[type="text"]').val()
    func = (x) -> eval val
    @drawGraph func

  drawGraph: (func) ->
    i = @cpt++
    str = '<canvas class="graph" id="canvas' + i + '" width="1000" height="500"></canvas>'
    @$el.find('.canvas-box').append str

    cv = document.getElementById 'canvas' + i
    context = cv.getContext '2d'
    dx    = 4
    x0    = @axes.x0
    y0    = @axes.y0
    scale = @axes.scale
    iMax  = Math.round (context.canvas.width - x0) / dx
    iMin  = if @axes.doNegativeX then Math.round(-x0 / dx) else 0
    context.beginPath()
    context.lineWidth = 1
    context.strokeStyle = 'rgb(66,44,255)'

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


appView = new AppView()