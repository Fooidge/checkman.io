gulp = require 'gulp'
bump = require 'gulp-bump'
concat = require 'gulp-concat'
inject = require 'gulp-inject'
sass = require 'gulp-sass'
svgstore = require 'gulp-svgstore'
uglify = require 'gulp-uglify'

gulp.task 'sass', ->
	gulp.src './sass/master.scss'
	.pipe sass
		errLogToConsole: true
	.pipe gulp.dest './styles'

gulp.task 'watch', ->
	gulp.watch ['./sass/*.scss'], ['sass']

gulp.task 'build', ->
	gulp.src './src/*.js'
	.pipe uglify
		preserveComments: 'some'
	gulp.dest './dist'

gulp.task 'bump-patch', ->
	gulp.src ['./package.json', 'bower.json']
	.pipe bump
		type: 'patch'
	.pipe gulp.dest './'

gulp.task 'bump-minor', ->
	gulp.src ['./package.json', 'bower.json']
	.pipe bump
		type: 'minor'
	.pipe gulp.dest './'

gulp.task 'bump-major', ->
	gulp.src ['./package.json', 'bower.json']
	.pipe bump
		type: 'major'
	.pipe gulp.dest './'

gulp.task 'svgstore', ->
	svgs = gulp.src './images/svg/*.svg'
	.pipe svgstore
		fileName: 'icons.svg'
		prefix: 'icon-'
	.pipe gulp.dest './images'

	target = gulp.src './index.html'
	sources = gulp.src ['./images/icons.svg'], read: false
	target.pipe inject sources
	.pipe gulp.dest './'

gulp.task 'default', ->
	gulp.start 'sass'