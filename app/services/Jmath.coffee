angular.module 'JC'
.factory 'jmath', ->
	getRandomIntInRange: (min, max) ->
		Math.floor(Math.random() * (max - min + 1)) + min

	getRandomInRange: (min, max) ->
		Math.random() * (max - min + 1) + min