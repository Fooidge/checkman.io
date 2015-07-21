angular.module 'JC', ['JC-templates', 'ui.router', 'ngResource']

angular.module 'JC'
.config ($stateProvider, $urlRouterProvider) ->

	$urlRouterProvider
		.otherwise '/'

	$stateProvider
		.state 'main',
			url: '/'
			templateUrl: 'pages/main.html'

	return