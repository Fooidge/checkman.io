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

		_clearCanvas = -> _context.clearRect 0, 0, _screenWidth, _screenHeight

		_drawParticle = ->

		_animate = ->


		return