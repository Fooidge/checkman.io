angular.module("JC-templates", []).run(["$templateCache", function($templateCache) {$templateCache.put("components/animatedBackground.html","<canvas class=\"animatedBackground\"></canvas>");
$templateCache.put("pages/main.html","<div class=\"heroPage u-maxXY u-flex u-centerXY\"><animated-background></animated-background><!-- <div class=\"heroPage-content u-flex u-column u-centerXY\">\n		<svg class=\"heroPage-logo\">\n			<use xlink:href=\"#icon-logo\">\n		</svg>\n		<h1 class=\"heroPage-salutation\">I\'m <strong>Jordan Checkman</strong>.</h1>\n		<h2 class=\"heroPage-salutation\">I make products.</h2>\n	</div> --><button class=\"button button--hero button--work\">Work</button></div>");
$templateCache.put("icons.svg","<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\"><svg xmlns=\"http://www.w3.org/2000/svg\"><symbol id=\"icon-logo\" viewBox=\"0 0 261 209\"><path class=\"logo-path\" d=\"M185.52 0h4.97c14.99.79 30.29 4.8 42.18 14.33 14.5 11.47 24.45 28.39 27.65 46.57-11.01.24-22.03.2-33.05.02-3.26-8.61-8.19-16.95-15.88-22.29-9.58-6.7-22.1-8.38-33.37-5.81-11.07 2.53-20.64 10.29-25.93 20.27-3.74 7.35-4.46 15.74-5.04 23.84-.59 13.86-.88 27.75-.46 41.63.31 9.99.32 20.13 2.77 29.89 2.46 10.06 9.6 18.64 18.61 23.57 11.45 6.79 26.41 7.08 38.3 1.25 9.92-4.84 16.19-14.36 21.18-23.82 10.92-.12 21.84-.12 32.77-.01-3.68 18.55-13.77 36.42-29.68 47.11-11.96 8.23-26.49 11.92-40.88 12.45h-2.3c-11.16-.73-22.49-2.64-32.52-7.83-9.15-4.83-17.32-11.44-24.18-19.18-2.89 3-5.85 5.94-8.95 8.73-25.55 22.43-66.9 24.08-94.07 3.61C13.42 183.56 4.69 166.91.86 149.74c10.94-.16 21.89-.32 32.82.1 4.17 8.16 9.34 16.19 17.13 21.32 8.39 5.74 19.07 7.38 28.99 5.85 14.44-2.47 27.65-13.14 31.61-27.49 3.56-13.17 3.2-27 2.87-40.53.17-35.63.07-71.26.07-106.89 10.32-.23 20.65-.15 30.97-.06.06 3.67.1 7.33.22 10.99 4.03-2.55 8.13-5.02 12.48-7C166.67 2.2 176.15.78 185.52 0z\"/></symbol></svg>");}]);
angular.module('JC', ['JC-templates', 'ui.router', 'ngResource']);

angular.module('JC').config(["$stateProvider", "$urlRouterProvider", function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise('/');
  $stateProvider.state('main', {
    url: '/',
    templateUrl: 'pages/main.html'
  });
}]);

var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

angular.module('JC').directive('animatedBackground', function() {
  return {
    restrict: 'E',
    bindToController: true,
    controllerAs: 'canvas',
    replace: true,
    templateUrl: 'components/animatedBackground.html',
    controller: ["$window", "$element", "jmath", function($window, $element, jmath) {
      var Attractor, Particle, _MAX_ATTRACTORS, _MAX_PARTICLES, _PARTICLE_DECAY_RATE, _animate, _canvas, _changeGravity, _clearCanvas, _clearParticle, _context, _screenCenter, _screenHeight, _screenWidth, attractors, i, j, mouseClick, mousePosition, part, particles, ref, resizeCanvas;
      _MAX_PARTICLES = 150;
      _MAX_ATTRACTORS = 1;
      _PARTICLE_DECAY_RATE = 0.0025;
      _screenHeight = $window.innerHeight;
      _screenWidth = $window.innerWidth;
      _screenCenter = [_screenWidth / 2, _screenHeight / 2];
      _canvas = $element[0];
      _context = _canvas.getContext('2d');
      resizeCanvas = function() {
        _screenHeight = $window.innerHeight;
        _screenWidth = $window.innerWidth;
        _canvas.width = _screenWidth;
        _canvas.height = _screenHeight;
        _screenCenter = [_screenWidth / 2, _screenHeight / 2];
      };
      mousePosition = function(event) {
        var _cursorPosition, _rect;
        _rect = _canvas.getBoundingClientRect();
        _cursorPosition = {
          x: event.clientX - _rect.left,
          y: event.clientY - _rect.top
        };
        _changeGravity(event);
      };
      mouseClick = function(event) {
        var att;
        att = new Attractor(event.clientX, event.clientY);
        attractors.unshift(att);
        if (attractors.length > _MAX_ATTRACTORS) {
          attractors.pop();
        }
      };
      _changeGravity = function(event) {
        var j, len, movement, part, results;
        if (event.movementX || event.mozMovementX) {
          movement = {
            x: event.movementX || event.mozMovementX || 0,
            y: event.movementY || event.mozMovementY || 0
          };
          results = [];
          for (j = 0, len = particles.length; j < len; j++) {
            part = particles[j];
            part.x += movement.x / 5;
            results.push(part.y += movement.y / 5);
          }
          return results;
        }
      };
      _clearCanvas = function() {
        return _context.clearRect(0, 0, _screenWidth, _screenHeight);
      };
      Particle = (function() {
        function Particle() {
          this.draw = bind(this.draw, this);
          this.x = jmath.getRandomIntInRange(0, _screenWidth);
          this.y = jmath.getRandomIntInRange(0, _screenHeight);
          this.size = jmath.getRandomInRange(1.5, 2);
          this.lifeForce = 0;
          this.lifePeak = false;
          this.maxLifeForce = jmath.getRandomInRange(0.45, 1);
          this.velocity = [jmath.getRandomInRange(-1, 1), jmath.getRandomInRange(-1, 1)];
        }

        Particle.prototype.draw = function() {
          var attractor, j, len;
          if (this.lifeForce <= 0 && this.lifePeak) {
            this.constructor();
          }
          if (this.lifePeak) {
            this.lifeForce -= _PARTICLE_DECAY_RATE;
          } else if (!this.lifePeak) {
            this.lifeForce += _PARTICLE_DECAY_RATE;
          }
          if (this.lifeForce >= this.maxLifeForce) {
            this.lifePeak = true;
          }
          this.x += this.velocity[0];
          if (this.x > _screenWidth) {
            this.x = 0;
          } else if (this.x < 0) {
            this.x = _screenWidth;
          }
          this.y += this.velocity[1];
          if (this.y > _screenHeight) {
            this.y = 0;
          } else if (this.y < 0) {
            this.y = _screenHeight;
          }
          for (j = 0, len = attractors.length; j < len; j++) {
            attractor = attractors[j];
            this.x += 100 / Math.pow(this.x - attractor.x, 2);
            this.y += 100 / Math.pow(this.y - attractor.y, 2);
          }
          _context.beginPath();
          _context.arc(this.x, this.y, this.size, 0, 2 * Math.PI, false);
          _context.fillStyle = "rgba(255, 255, 255, " + this.lifeForce + ")";
          return _context.fill();
        };

        return Particle;

      })();
      Attractor = (function() {
        function Attractor(x, y) {
          if (x == null) {
            x = 0;
          }
          if (y == null) {
            y = 0;
          }
          this.draw = bind(this.draw, this);
          this.x = x;
          this.y = y;
          this.size = 10;
        }

        Attractor.prototype.draw = function() {
          _context.beginPath();
          _context.arc(this.x, this.y, this.size, 0, 2 * Math.PI, false);
          _context.fillStyle = "rgba(0, 0, 0, 0.25)";
          return _context.fill();
        };

        return Attractor;

      })();
      _clearParticle = function(particle) {
        var particleRadius, xEnd, xStart, yEnd, yStart;
        particleRadius = particle.size * Math.PI;
        xStart = particle.x - particleRadius;
        xEnd = particle.x + particleRadius;
        yStart = particle.y - particleRadius;
        yEnd = particle.y + particleRadius;
        _context.clearRect(xStart, yStart, xEnd, yEnd);
      };
      _animate = function() {
        var attractor, j, k, len, len1, part;
        _clearCanvas();
        for (j = 0, len = particles.length; j < len; j++) {
          part = particles[j];
          part.draw();
        }
        for (k = 0, len1 = attractors.length; k < len1; k++) {
          attractor = attractors[k];
          attractor.draw();
        }
        requestAnimationFrame(_animate);
      };
      resizeCanvas();
      $window.addEventListener('resize', resizeCanvas, false);
      _canvas.addEventListener('mousemove', function(evt) {
        return mousePosition(evt, false);
      });
      _canvas.addEventListener('click', function(evt) {
        return mouseClick(evt, false);
      });
      particles = [];
      attractors = [];
      for (i = j = 0, ref = _MAX_PARTICLES; j <= ref; i = j += 1) {
        part = new Particle();
        particles.push(part);
      }
      _animate();
    }]
  };
});

angular.module('JC').factory('jmath', function() {
  return {
    getRandomIntInRange: function(min, max) {
      return Math.floor(Math.random() * (max - min + 1)) + min;
    },
    getRandomInRange: function(min, max) {
      return Math.random() * (max - min + 1) + min;
    }
  };
});
