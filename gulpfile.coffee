gulp = require 'gulp'
bump = require 'gulp-bump'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
csscomb = require 'gulp-csscomb'
inject = require 'gulp-inject'
rename = require 'gulp-rename'
sass = require 'gulp-sass'
svgmin = require 'gulp-svgmin'
svgstore = require 'gulp-svgstore'
symlink = require 'gulp-sym'
uglify = require 'gulp-uglify'

gulp.task 'sass', ->
	gulp.src './sass/master.scss'
	.pipe sass
		errLogToConsole: true
	.pipe csscomb()
	.pipe gulp.dest './htdocs/styles'

gulp.task 'build', ->
	gulp.src './app/**/*.coffee'
	.pipe coffee
		bare: true
	.pipe concat 'main.js'
	# .pipe uglify
	# 	preserveComments: 'some'
	.pipe gulp.dest './htdocs/js'

gulp.task 'link', ->
	gulp.src './bower_components/bourbon/app/assets/stylesheets'
		.pipe symlink './sass/bourbon'
	gulp.src './bower_components/neat/app/assets/stylesheets'
		.pipe symlink './sass/neat'

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

gulp.task 'svg', ->
	gulp.src './images/svg/*.svg'
	.pipe rename
		prefix: 'icon-'
	.pipe svgstore()
	.pipe svgmin
		js2svg:
			pretty: true
	.pipe rename 'icons.svg'
	.pipe gulp.dest './images'

	# target = gulp.src './index.html'
	# sources = gulp.src ['./images/icons.svg'], read: false
	# target.pipe inject sources
	# .pipe gulp.dest './'

gulp.task 'default', ->
	gulp.start 'sass'

gulp.task 'watch', ->
	gulp.watch ['./sass/*.scss'], 'sass'
