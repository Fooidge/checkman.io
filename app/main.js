(function() {

	var requestAnimationFrame = (
			window.requestAnimationFrame       ||
			window.webkitRequestAnimationFrame ||
			window.mozRequestAnimationFrame    ||
			window.oRequestAnimationFrame      ||
			window.msRequestAnimationFrame     ||
			function( callback ){
				window.setTimeout(callback, 1000 / 60);
			}
		);

	var width, height, canvas, ctx, circles, target, animateHeader = true;

	// Main
	initHeader();
	addListeners();

	function initHeader() {
		width = window.innerWidth;
		height = window.innerHeight;
		target = {x: 0, y: height};

		canvas = document.getElementById('hero-background');
		canvas.width = width;
		canvas.height = height;
		ctx = canvas.getContext('2d');

		// create particles
		circles = [];
		for(var x = 0; x < width * 0.1; x++) {
			var c = new Circle();
			circles.push(c);
		}
		animate();
	}

	// Event handling
	function addListeners() {
		window.addEventListener('scroll', scrollCheck);
		window.addEventListener('resize', resize);
	}

	function scrollCheck() {
		if(document.body.scrollTop > height) animateHeader = false;
		else animateHeader = true;
	}

	function resize() {
		width = window.innerWidth;
		height = window.innerHeight;
		canvas.width = width;
		canvas.height = height;
	}

	function animate() {
		if(animateHeader) {
			ctx.clearRect(0, 0, width, height);
			for(var i in circles) {
				circles[i].draw();
			}
		}
		requestAnimationFrame(animate);
	}

	// Canvas manipulation
	function Circle() {
		var _this = this;

		// constructor
		(function() {
			_this.pos = {};
			init();
		})();

		function init() {
			var plusOrMinus = Math.random() < 0.5 ? -1 : 1;
			var Z = 0.1 + Math.random() * 0.7;
			var Xpos = Math.random();
			_this.pos.x = Xpos * width;
			_this.pos.y = (height/2)+Math.random()*(height/2)*plusOrMinus;
			_this.alpha = 0.8 - Z;
			_this.scale = Z;
			_this.velocity = [Math.random(), (Math.random() * plusOrMinus), Math.random()*0.001];
		}

		this.draw = function() {
			if(_this.alpha <= 0) {
				init();
			}
			var plusOrMinus = Math.random() < 0.5 ? -1 : 1;
			_this.pos.x += _this.velocity[0];
			_this.pos.y += _this.velocity[1];
			_this.alpha -= _this.velocity[2];
			_this.scale += _this.velocity[2];
			ctx.beginPath();
			ctx.arc(_this.pos.x, _this.pos.y, _this.scale*10, 0, 2 * Math.PI, false);
			ctx.fillStyle = 'rgba(208,100,78,'+ _this.alpha+')';
			ctx.fill();
		};
	}

})();