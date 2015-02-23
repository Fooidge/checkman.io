(function() {
  var Circle, addListeners, animate, animateHeader, initHeader, requestAnimationFrame, resize, scrollCheck;
  requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback) {
    return window.setTimeout(callback, 1000 / 60);
  };
  animateHeader = true;
  initHeader = function() {
    var c, canvas, circles, ctx, height, i, j, ref, target, width;
    width = window.innerWidth;
    height = window.innerHeight;
    target = {
      x: 0,
      y: height
    };
    canvas = document.getElementById('hero-background');
    canvas.width = width;
    canvas.height = height;
    ctx = canvas.getContext('2d');
    circles = [];
    for (i = j = 0, ref = width * 0.1; j <= ref; i = j += 1) {
      c = new Circle();
      cirles.push(c);
    }
    animate();
  };
  addListeners = function() {
    window.addEventListener('scroll', scrollCheck);
    window.addEventListener('resize', resize);
  };
  scrollCheck = function() {
    if (document.body.scrollTop > height) {
      animateHeader = false;
    } else {
      animateHeader = true;
    }
  };
  resize = function() {
    var height, width;
    width = window.innerWidth;
    height = window.innerHeight;
    canvas.width = width;
    canvas.height = height;
  };
  animate = function() {
    var i, j, len;
    if (animateHeader) {
      ctx.clearRect(0, 0, width, height);
      for (j = 0, len = circles.length; j < len; j++) {
        i = circles[j];
        i.draw();
      }
    }
    requestAnimationFrame(animate);
  };
  Circle = function() {
    var _this, init;
    _this = this;
    (function() {
      _this.pos = {};
      init();
    })();
    init = function() {
      var Xpos, Z, plusOrMinus;
      plusOrMinus = Math.random() < 0.5 ? -1 : 1;
      Z = 0.1 + Math.random() * 0.7;
      Xpos = Math.random();
      _this.pos.x = Xpos * width;
      _this.pos.y = (height / 2) + Math.random() * (height / 2) * plusOrMinus;
      _this.alpha = 0.8 - Z;
      _this.scale = Z;
      _this.velocity = [Math.random(), Math.random() * plusOrMinus, Math.random() * 0.001];
    };
    this.draw = function() {
      var plusOrMinus;
      if (_this.alpha <= 0) {
        init();
      }
      plusOrMinus = Math.random() < 0.5 ? -1 : 1;
      _this.pos.x += _this.velocity[0];
      _this.pos.y += _this.velocity[1];
      _this.alpha -= _this.velocity[2];
      _this.scale += _this.velocity[2];
      ctx.beginPath();
      ctx.arc(_this.pos.x, _this.pos.y, _this.scale * 10, 0, 2 * Math.PI, false);
      ctx.fillStyle = "rgba(208,100,78," + _this.alpha + ")";
      ctx.fill();
    };
  };
  initHeader();
  return addListeners();
})();
