angular.module 'JC'
.directive 'animatedBackground', ->
	restrict: 'E'
	bindToController: true
	controllerAs: 'canvas'
	replace: true
	templateUrl: 'components/animatedBackground.html'
	controller: ($window, $element) ->
		_MAX_PARTICLES = 150
		_PARTICLE_DECAY_RATE = 0.005
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
			_cursorPosition = {
				x: event.clientX - _rect.left
				y: event.clientY - _rect.top
			}
			_changeGravity event
			return

		_changeGravity = (event) ->
			if event.movementX or event.mozMovementX
				movement =
					x: event.movementX or event.mozMovementX or 0
					y: event.movementY or event.mozMovementY or 0
				console.log movement
				for part in particles
					part.x += movement.x/5
					part.y += movement.y/5


		_clearCanvas = -> _context.clearRect 0, 0, _screenWidth, _screenHeight

		_getRandomIntInRange = (min, max) ->
			Math.floor(Math.random() * (max - min + 1)) + min;

		_getRandomInRange = (min, max) ->
			Math.random() * (max - min + 1) + min;

		class Particle
			constructor: ->
				@x = _getRandomIntInRange 0, _screenWidth
				@y = _getRandomIntInRange 0, _screenHeight
				@size = _getRandomInRange 1.5, 2
				@lifeForce = 0
				@lifePeak = false
				@maxLifeForce = _getRandomInRange 0.45 , 1
				@velocity = [
					_getRandomInRange -1, 1
					_getRandomInRange -1, 1
					_getRandomInRange -1, 1
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
				_context.beginPath()
				_context.arc @x, @y, @size, 0, 2 * Math.PI, false
				_context.fillStyle = "rgba(255, 255, 255 ,#{@lifeForce})"
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

			requestAnimationFrame _animate

		resizeCanvas()
		$window.addEventListener 'resize', resizeCanvas, false
		_canvas.addEventListener 'mousemove', (evt) -> mousePosition evt , false
		particles = []
		for i in [0.._MAX_PARTICLES] by 1
			part = new Particle()
			particles.push part
		_animate()

		return