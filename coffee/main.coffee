# Backbone

Graph = Backbone.Model.extend
  initialize: ->


GraphCollection = Backbone.Collection.extend
  cpt: 0
  initialize: ->


GraphView = Backbone.View.extend

  el: 'ul.graph-list'

  axes:
    x0: .5 + .5 * canvas.width  # x0 pixels from left to x=0
    y0: .5 + .5 * canvas.height # y0 pixels from top to y=0
    scale: 20
    doNegativeX: yes

  initialize: (options) ->
    @model      = options.model
    @collection = options.collection
    @render()

  render: ->
    @drawGraph @model
    @$el.append '<li>' + @model.get('funcStr') + '</li>'

  drawGraph: (graph) ->
    i = @collection.cpt++
    str = '<canvas class="graph" id="canvas' + i + '" width="' + canvas.width + '" height="' + canvas.height + '"></canvas>'
    $('.canvas-box').append str

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

    func = graph.get('func')

    i = iMin
    loop
      xx = dx * i;
      yy = scale * func(xx / scale)
      if i is iMin then context.moveTo(x0 + xx, y0 - yy) else context.lineTo(x0 + xx, y0 - yy)
      i = i + 0.1
      break if i > iMax

    context.stroke()


AppView = Backbone.View.extend
  el: 'body'
  events:
    'submit form': 'handleForm'

  initialize: ->
    canvas = document.getElementById 'canvas'
    ctx  = canvas.getContext '2d'
    axes =
      x0: .5 + .5 * canvas.width  # x0 pixels from left to x=0
      y0: .5 + .5 * canvas.height # y0 pixels from top to y=0
      scale: 20
      doNegativeX: yes
    @graphCollection = new GraphCollection()

    # Show axes
    x0   = axes.x0
    y0   = axes.y0
    xmin = if axes.doNegativeX then 0 else x0

    ctx.beginPath()
    ctx.strokeStyle = 'rgb(128,128,128)'
    ctx.moveTo xmin, y0
    ctx.lineTo ctx.canvas.width, y0
    ctx.moveTo x0, 0
    ctx.lineTo x0, ctx.canvas.height
    ctx.stroke()

    # Draw sample graph
    sample = 'Math.log(x)'
    @addGraph sample

  handleForm: (e) ->
    e.preventDefault()
    $form = $(e.target)
    $input = $form.find('input[type="text"]')
    val = $input.val()
    $input.val('')
    @addGraph(val) if val.length

  addGraph: (val) ->
    func = (x) -> eval(val)
    graph = new Graph(funcStr: val, func: func)
    @graphCollection.add(new GraphView(model: graph, collection: @graphCollection))

  clearFunction = (number) ->
    $('#canvas' + number).remove();


window.appView = new AppView()