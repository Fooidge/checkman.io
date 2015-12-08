angular.module 'JC'
.directive 'animatedBackground', ->
	restrict: 'E'
	bindToController: true
	controllerAs: 'canvas'
	replace: true
	templateUrl: 'components/animatedBackground.html'
	controller: ($window, $element) ->
		_MAX_PARTICLES = 25
		_PARTICLE_DECAY_RATE = 0.0025
		_screenHeight = $window.innerHeight
		_screenWidth = $window.innerWidth
		_canvas = $element[0]
		_context = _canvas.getContext '2d'

		resizeCanvas = ->
			_screenHeight = $window.innerHeight
			_screenWidth = $window.innerWidth
			_canvas.width = _screenWidth
			_canvas.height = _screenHeight
			return

		_clearCanvas = -> _context.clearRect 0, 0, _screenWidth, _screenHeight

		class Particle
			constructor: ->
				@initialize()

			initialize: =>
				@x = _.random 0, _screenWidth
				@y = _.random 0, _screenHeight
				@size = _.random 1.5, 3.5, true
				@lifeForce = 0
				@lifePeak = false
				@maxLifeForce = _.random 0.45, 1, true
				@velocity = [
					_.random -1, 1, true
					_.random -1, 1, true
				]
				return

			draw: =>
				if @lifeForce <= 0 and @lifePeak then @initialize()
				#changes
				if @lifePeak then @lifeForce -= _PARTICLE_DECAY_RATE
				else if !@lifePeak then @lifeForce += _PARTICLE_DECAY_RATE
				if @lifeForce >= @maxLifeForce then @lifePeak = true
				#If particle leaves screen, put them on the other side
				@x += @velocity[0]
				if @x > _screenWidth then @x = 0
				else if @x < 0 then @x = _screenWidth
				@y += @velocity[1]
				if @y > _screenHeight then @y = 0
				else if @y < 0 then @y = _screenHeight
				#draw
				_context.beginPath()
				_context.arc @x, @y, @size, 0, 2 * Math.PI, false
				_context.fillStyle = "rgba(255, 255, 255, #{@lifeForce})"
				_context.fill()
				return

		_animate = ->
			_clearCanvas()
			for part in particles
				part.draw()
			requestAnimationFrame _animate
			return

		resizeCanvas()
		$window.addEventListener 'resize', resizeCanvas, false
		particles = []
		for i in [0.._MAX_PARTICLES] by 1
			part = new Particle()
			particles.push part
		_animate()

		return