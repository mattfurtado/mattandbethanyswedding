gulp = require('gulp')
plugins = require('gulp-load-plugins')()
server = require('tiny-lr')()
path = require('path')
connect = require('gulp-connect')
browserify = require('gulp-browserify')
gulpif = require('gulp-if')

gulp.task 'connect', ->
  plugins.connect.server
    root: ''
    livereload: true

gulp.task 'styles', ->
  gulp.src('sass/*.sass')
    .pipe(plugins.compass({
      style: 'expanded'
      css: 'css'
      sass: 'sass'
      image: 'img'
    }))
    .pipe(plugins.autoprefixer('last 2 versions', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
    .pipe(gulp.dest('css'))
    .pipe(plugins.rename({suffix: '.min'}))
    .pipe(plugins.minifyCss())
    .pipe(gulp.dest('css'))
    .pipe(connect.reload())
    .pipe(plugins.notify({message: 'Styles task complete'}))

gulp.task 'scripts', ->
  gulp.src('coffee/*.coffee')
    .pipe(plugins.coffee({bare: true, sourceMap: true}))
    .pipe(gulp.dest('js'))
    .pipe(plugins.concat('main.js'))
    .pipe(gulp.dest('js'))
    .pipe(plugins.rename({suffix: '.min'}))
    .pipe(plugins.uglify({outSourceMap: true, preserveComments: 'some'}))
    .pipe(gulp.dest('js'))
    .pipe(connect.reload())
    .pipe(plugins.notify({message: 'Scripts task complete'}))

gulp.task 'html', ->
  gulp.src('*.html')
    .pipe(connect.reload())

gulp.task 'default', [
  'connect'
  'styles'
  'scripts'
  'watch'
]

gulp.task 'watch', ->
  gulp.watch('*.html', ['html'])
  gulp.watch('sass/*.sass', ['styles'])
  gulp.watch('coffee/*.coffee', ['scripts'])
