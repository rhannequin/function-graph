// Print axes
lauch = function () {
  var canvas = document.getElementById("canvas");

  axes.x0 = .5 + .5*canvas.width;  // x0 pixels from left to x=0
  axes.y0 = .5 + .5*canvas.height; // y0 pixels from top to y=0
  axes.scale = 20;
  axes.doNegativeX = true;

  // Show axes
  var x0=axes.x0, w=ctx.canvas.width;
  var y0=axes.y0, h=ctx.canvas.height;
  var xmin = axes.doNegativeX ? 0 : x0;
  ctx.beginPath();
  ctx.strokeStyle = "rgb(128,128,128)";
  ctx.moveTo(xmin,y0); ctx.lineTo(w,y0);  // X axis
  ctx.moveTo(x0,0);    ctx.lineTo(x0,h);  // Y axis
  ctx.stroke();
};

if (typeof canvas !== 'undefined' && typeof canvas.getContext !== 'undefined') {
  var axes={}, ctx=canvas.getContext("2d");
  lauch();
}

// Function to create graphs
function funGraph (func, i) {
  str = '<canvas class="graph" id="canvas' + i + '" width="1000" height="500"></canvas>';
  $('.canvas-box').append(str);

  var cv = document.getElementById("canvas" + i);
  context=cv.getContext("2d");

  color = "rgb(66,44,255)";
  thick = 1;

  var xx, yy, dx=4, x0=axes.x0, y0=axes.y0, scale=axes.scale;
  var iMax = Math.round((context.canvas.width-x0)/dx);
  var iMin = axes.doNegativeX ? Math.round(-x0/dx) : 0;
  context.beginPath();
  context.lineWidth = thick;
  context.strokeStyle = color;

  var i = iMin;
  while(i <= iMax) {
    xx = dx*i;
    yy = scale * func(xx/scale);
    if (i == iMin) {
      context.moveTo(x0+xx,y0-yy);
    }
    else {
      context.lineTo(x0+xx,y0-yy);
    }
    i = i + 0.1
  }

  context.stroke();
}

function clearFunction (number) {
  $('#canvas' + number).remove();
}

var i = 0;

// Default printed function
func = function(x){return Math.log(x);};
funGraph(func, i++);

$('input:submit').click(function () {
  var val = $('input[type="text"]').val();
  var func = function (x) {
    return eval(val);
  }
  funGraph(func, i++);
});