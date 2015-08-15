angular.module 'JC'
.directive 'animatedBackground', ->
	restrict: 'E'
	bindToController: true
	controllerAs: 'canvas'
	replace: true
	templateUrl: 'components/animatedBackground.html'
	controller: ($window, $element) ->
		_MAX_PARTICLES = 25
		_MAX_ATTRACTORS = 1
		_PARTICLE_DECAY_RATE = 0.0025
		_screenHeight = $window.innerHeight
		_screenWidth = $window.innerWidth
		_screenCenter = [_screenWidth/2, _screenHeight/2]
		_canvas = $element[0]
		_context = _canvas.getContext '2d'

		resizeCanvas = ->
			_screenHeight = $window.innerHeight
			_screenWidth = $window.innerWidth
			_canvas.width = _screenWidth
			_canvas.height = _screenHeight
			_screenCenter = [_screenWidth/2, _screenHeight/2]
			return

		mousePosition = (event) ->
			_rect = _canvas.getBoundingClientRect()
			_cursorPosition =
				x: event.clientX - _rect.left
				y: event.clientY - _rect.top
			_changeGravity event
			return

		mouseClick = (event) ->
			att = new Attractor event.clientX, event.clientY
			attractors.unshift att
			if attractors.length > _MAX_ATTRACTORS
				attractors.pop()
			return


		_changeGravity = (event) ->
			if event.movementX or event.mozMovementX
				movement =
					x: event.movementX or event.mozMovementX or 0
					y: event.movementY or event.mozMovementY or 0
				for part in particles
					part.x += movement.x/5
					part.y += movement.y/5


		_clearCanvas = -> _context.clearRect 0, 0, _screenWidth, _screenHeight

		class Particle
			constructor: ->
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

			draw: =>
				if @lifeForce <= 0 and @lifePeak
					@constructor()
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
				#find closest attractor
				for attractor in attractors
					@x +=  100/Math.pow(@x - attractor.x, 2)
					@y += 100/Math.pow(@y - attractor.y, 2)
				#draw
				_context.beginPath()
				_context.arc @x, @y, @size, 0, 2 * Math.PI, false
				_context.fillStyle = "rgba(255, 255, 255, #{@lifeForce})"
				_context.fill()

		class Attractor
			constructor: (x = 0, y = 0) ->
				@x = x
				@y = y
				@size = 10

			draw: =>
				_context.beginPath()
				_context.arc @x, @y, @size, 0, 2 * Math.PI, false
				_context.fillStyle = "rgba(0, 0, 0, 0.25)"
				_context.fill()

		_clearParticle = (particle) ->
			particleRadius = particle.size * Math.PI
			xStart = particle.x - particleRadius
			xEnd = particle.x + particleRadius
			yStart = particle.y - particleRadius
			yEnd = particle.y + particleRadius
			_context.clearRect xStart, yStart, xEnd, yEnd
			return

		_animate = ->
			_clearCanvas()
			for part in particles
				# _clearParticle part
				part.draw()
			for attractor in attractors
				attractor.draw()

			requestAnimationFrame _animate
			return

		resizeCanvas()
		$window.addEventListener 'resize', resizeCanvas, false
		_canvas.addEventListener 'mousemove', (evt) -> mousePosition evt , false
		_canvas.addEventListener 'click', (evt) -> mouseClick evt , false
		particles = []
		attractors = []
		for i in [0.._MAX_PARTICLES] by 1
			part = new Particle()
			particles.push part
		_animate()

		return