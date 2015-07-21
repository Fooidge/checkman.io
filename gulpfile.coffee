gulp = require 'gulp'
annotate = require 'gulp-ng-annotate'
autoprefixer = require 'gulp-autoprefixer'
bump = require 'gulp-bump'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
rename = require 'gulp-rename'
sass = require 'gulp-sass'
svgstore = require 'gulp-svgstore'
svgmin = require 'gulp-svgmin'
symlink = require 'gulp-symlink'
merge = require 'merge-stream'
ngTemplates = require 'gulp-ng-templates'
uglify = require 'gulp-uglify'
htmlmin = require 'gulp-htmlmin'

swallowError = (error) ->
	console.error error.toString()
	this.emit 'end'

src =
	bourbon: './bower_components/bourbon/app/assets/stylesheets'
	neat: './bower_components/neat/app/assets/stylesheets'
	sass: './sass/master.scss'
	allSass: './sass/**/*.scss'
	app: './app/**/*.coffee'
	templates: [
		'./app/templates/**/*.html'
		'./images/icons.svg'
	]
	icons: './images/svg/*.svg'
	imagesLink: './images'

dest =
	js: './htdocs/js'
	css: './htdocs/css'
	images: './images'
	bourbon: './sass/bourbon'
	neat: './sass/neat'
	imagesLink: './htdocs/images'

libs = [
	'bower_components/angular/angular.js'
	'bower_components/angular-animate/angular-animate.js'
	'bower_components/angular-resource/angular-resource.js'
	'bower_components/angular-ui-router/release/angular-ui-router.js'
	'bower_components/jquery/dist/jquery.js'
	'bower_components/lodash/lodash.js'
	'bower_components/moment/moment.js'
	'bower_components/velocity/velocity.js'
	# 'bower_components/d3/d3.js'
]

gulp.task 'libs', ->
	gulp.src libs
	.pipe concat 'libs.js'
	.pipe gulp.dest dest.js

gulp.task 'build', ['icons'], ->
	app = gulp.src src.app
	.pipe coffee
		bare: true
	.on 'error', swallowError
	.pipe annotate
		singleQuotes: true
	.on 'error', swallowError
	.pipe concat 'JC.js'
	.pipe gulp.dest dest.js

	templates = gulp.src src.templates
	.pipe htmlmin
		collapseWhitespace: true
	.pipe ngTemplates 'JC-templates'
	.on 'error', swallowError
	.pipe concat 'JC.templates.js'
	.pipe gulp.dest dest.js

	merge app, templates
	.pipe concat 'JC.js'
	.pipe gulp.dest dest.js

gulp.task 'default', ->
	gulp.start 'build'
	gulp.start 'sass'

gulp.task 'sass', ->
	gulp.src src.sass
	.pipe sass
		outputStyle: 'compressed'
	.on 'error', swallowError
	.pipe autoprefixer
		browsers: ['last 2 versions']
		cascade: false
	.on 'error', swallowError
	.pipe gulp.dest dest.css

gulp.task 'icons', ->
	gulp.src src.icons
	.pipe rename
		prefix: 'icon-'
	.pipe svgmin
		js2svg:
			pretty: true
	.pipe svgstore()
	.pipe rename 'icons.svg'
	.pipe gulp.dest dest.images

gulp.task 'link', ->
	gulp.src src.bourbon
	.pipe symlink dest.bourbon,
		force: true

	gulp.src src.neat
	.pipe symlink dest.neat,
		force: true

	gulp.src src.imagesLink
	.pipe symlink dest.imagesLink,
		force: true

gulp.task 'watch', ->
	gulp.watch src.allSass, ['sass']
	gulp.watch [src.app, src.templates[0]], ['build']
	gulp.watch src.icons, ['icons']