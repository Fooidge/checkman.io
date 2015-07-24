angular.module 'JC'
.directive 'animatedBackground', ->
	restrict: 'E'
	bindToController: true
	controllerAs: 'canvas'
	replace: true
	templateUrl: 'components/animatedBackground.html'
	controller: ($window, $element) ->
		_MAX_PARTICLES = 100
		_screenHeight = $window.outerHeight
		_screenWidth = $window.outerWidth
		_canvas = $element[0]
		_context = _canvas.getContext '2d'

		resizeCanvas = ->
			_screenHeight = $window.outerHeight
			_screenWidth = $window.outerWidth
			_canvas.width = _screenWidth
			_canvas.height = _screenHeight

		_clearCanvas = -> _context.clearRect 0, 0, _screenWidth, _screenHeight

		_getRandomIntInRange = (min, max) ->
			Math.floor(Math.random() * (max - min + 1)) + min;

		_getRandomInRange = (min, max) ->
			Math.random() * (max - min + 1) + min;

		class Partical
			constructor: ->
				@x = _getRandomIntInRange 0, _screenWidth
				@y = _getRandomIntInRange 0, _screenHeight
				@size = _getRandomInRange 0.5, 1.5
				@lifeForce = _getRandomInRange 0.45 , 1
				@velocity = Math.random()

			draw: =>
				if @lifeForce <= 0
					@constructor()
				#changes
				@lifeForce -= 0.0005
				@x += 0.05
				@y += 0.05
				_context.beginPath()
				_context.arc @x, @y, @size, 0, 2 * Math.PI, false
				_context.fillStyle = "rgba(255, 255, 255 ,#{@lifeForce})"
				_context.fill()


		_animate = ->
			_clearCanvas()
			for part in particals
				part.draw()

			requestAnimationFrame _animate

		resizeCanvas()
		$window.addEventListener 'resize', resizeCanvas, false
		particals = []
		for i in [0.._MAX_PARTICLES] by 1
			part = new Partical()
			particals.push part
		_animate()

		return