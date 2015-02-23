do ->

	requestAnimationFrame =
		window.requestAnimationFrame       or
		window.webkitRequestAnimationFrame or
		window.mozRequestAnimationFrame    or
		window.oRequestAnimationFrame      or
		window.msRequestAnimationFrame     or
		(callback) ->
			window.setTimeout callback, 1000 / 60


	animateHeader = true

	initHeader = ->
		width = window.innerWidth
		height = window.innerHeight
		target =
			x: 0
			y: height

		canvas = document.getElementById 'hero-background'
		canvas.width = width
		canvas.height = height
		ctx = canvas.getContext '2d'

		#create particles
		circles = []
		for i in [0..width*0.1] by 1
			c = new Circle()
			cirles.push c
		animate()
		return

	#Event handling
	addListeners = ->
		window.addEventListener 'scroll', scrollCheck
		window.addEventListener 'resize', resize
		return

	scrollCheck = ->
		if document.body.scrollTop > height
			animateHeader = false
		else
			animateHeader = true
		return


	resize = ->
		width = window.innerWidth
		height = window.innerHeight
		canvas.width = width
		canvas.height = height
		return

	animate = ->
		if animateHeader
			ctx.clearRect 0, 0, width, height
			for i in circles
				i.draw()
		requestAnimationFrame animate
		return

	#Canvas manipulation
	Circle = ->
		_this = this

		#constructor
		do ->
			_this.pos = {}
			init()
			return

		init = ->
			plusOrMinus = if Math.random() < 0.5 then -1 else 1
			Z = 0.1 + Math.random() * 0.7
			Xpos = Math.random()
			_this.pos.x = Xpos * width
			_this.pos.y = (height/2) + Math.random() * (height/2) * plusOrMinus
			_this.alpha = 0.8 - Z
			_this.scale = Z
			_this.velocity = [Math.random(), (Math.random() * plusOrMinus), Math.random() * 0.001]
			return

		@draw = ->
			if _this.alpha <= 0
				init()
			plusOrMinus = if Math.random() < 0.5 then -1 else 1
			_this.pos.x += _this.velocity[0]
			_this.pos.y += _this.velocity[1]
			_this.alpha -= _this.velocity[2]
			_this.scale += _this.velocity[2]
			ctx.beginPath()
			ctx.arc _this.pos.x, _this.pos.y, _this.scale*10, 0, 2 * Math.PI, false
			ctx.fillStyle = "rgba(208,100,78,#{_this.alpha})"
			ctx.fill()
			return

		return

	#Main
	initHeader()
	addListeners()
