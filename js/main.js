// Generated by CoffeeScript 1.4.0
(function() {
  var AppView, Graph, GraphCollection, GraphView, clearFunction;

  Graph = Backbone.Model.extend({
    initialize: function() {}
  });

  GraphCollection = Backbone.Collection.extend({
    cpt: 0,
    initialize: function() {}
  });

  GraphView = Backbone.View.extend({
    el: 'ul.graph-list',
    axes: {
      x0: .5 + .5 * canvas.width,
      y0: .5 + .5 * canvas.height,
      scale: 20,
      doNegativeX: true
    },
    initialize: function(options) {
      this.model = options.model;
      this.collection = options.collection;
      return this.render();
    },
    render: function() {
      this.drawGraph(this.model);
      return this.$el.append('<li>' + this.model.get('funcStr') + '</li>');
    },
    drawGraph: function(graph) {
      var context, cv, dx, func, i, iMax, iMin, scale, str, x0, xx, y0, yy;
      i = this.collection.cpt++;
      str = '<canvas class="graph" id="canvas' + i + '" width="1000" height="500"></canvas>';
      $('.canvas-box').append(str);
      cv = document.getElementById('canvas' + i);
      context = cv.getContext('2d');
      dx = 4;
      x0 = this.axes.x0;
      y0 = this.axes.y0;
      scale = this.axes.scale;
      iMax = Math.round((context.canvas.width - x0) / dx);
      iMin = this.axes.doNegativeX ? Math.round(-x0 / dx) : 0;
      context.beginPath();
      context.lineWidth = 1;
      context.strokeStyle = 'rgb(66,44,255)';
      func = graph.get('func');
      i = iMin;
      while (true) {
        xx = dx * i;
        yy = scale * func(xx / scale);
        if (i === iMin) {
          context.moveTo(x0 + xx, y0 - yy);
        } else {
          context.lineTo(x0 + xx, y0 - yy);
        }
        i = i + 0.1;
        if (i > iMax) {
          break;
        }
      }
      return context.stroke();
    }
  });

  AppView = Backbone.View.extend({
    el: 'body',
    events: {
      'submit form': 'handleForm'
    },
    initialize: function() {
      var axes, canvas, ctx, sample, x0, xmin, y0;
      canvas = document.getElementById('canvas');
      ctx = canvas.getContext('2d');
      axes = {
        x0: .5 + .5 * canvas.width,
        y0: .5 + .5 * canvas.height,
        scale: 20,
        doNegativeX: true
      };
      this.graphCollection = new GraphCollection();
      x0 = axes.x0;
      y0 = axes.y0;
      xmin = axes.doNegativeX ? 0 : x0;
      ctx.beginPath();
      ctx.strokeStyle = 'rgb(128,128,128)';
      ctx.moveTo(xmin, y0);
      ctx.lineTo(ctx.canvas.width, y0);
      ctx.moveTo(x0, 0);
      ctx.lineTo(x0, ctx.canvas.height);
      ctx.stroke();
      sample = 'Math.log(x)';
      return this.addGraph(sample);
    },
    handleForm: function(e) {
      var form, val;
      e.preventDefault();
      form = $(e.target);
      val = form.find('input[type="text"]').val();
      return this.addGraph(val);
    },
    addGraph: function(val) {
      var func, graph;
      func = function(x) {
        return eval(val);
      };
      graph = new Graph({
        funcStr: val,
        func: func
      });
      return this.graphCollection.add(new GraphView({
        model: graph,
        collection: this.graphCollection
      }));
    }
  }, clearFunction = function(number) {
    return $('#canvas' + number).remove();
  });

  window.appView = new AppView();

}).call(this);
