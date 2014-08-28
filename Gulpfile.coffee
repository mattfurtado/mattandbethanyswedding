gulp = require('gulp')
plugins = require('gulp-load-plugins')()
server = require('tiny-lr')()
path = require('path')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
connect = require('gulp-connect')
browserify = require('gulp-browserify')
gulpif = require('gulp-if')
jade = require('gulp-jade')
autoprefixer = require('gulp-autoprefixer')
minifycss = require('gulp-minify-css')
rename = require('gulp-rename')
sass = require('gulp-ruby-sass')
plumber = require('gulp-plumber')
notify = require('gulp-notify')
uglify = require('gulp-uglify')

onError = (err) ->
  console.log(err)

gulp.task 'connect', ->
  plugins.connect.server
    root: ''
    livereload: true

gulp.task 'styles', ->
  gulp.src('./sass/*.sass')
    .pipe(plumber({
      errorHandler: onError
    }))
    .pipe(sass({style: 'expanded'}))
    .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 7', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
    .pipe(gulp.dest('./css'))
    # .pipe(notify({message: 'Styles task complete'}))
    # .pipe(rename({ suffix: '.min' }))
    # .pipe(minifycss())
    # .pipe(gulp.dest('css'))
    .pipe(connect.reload())

gulp.task 'scripts', ->
  gulp.src('./coffee/*.coffee')
    .pipe(plumber({
      errorHandler: onError
    }))
    .pipe(coffee({bare: true, sourceMap: true}))
    .pipe(gulp.dest('js'))
    .pipe(concat('main.js'))
    .pipe(gulp.dest('js'))
    .pipe(rename({suffix: '.min'}))
    .pipe(uglify({outSourceMap: true, preserveComments: 'some'}))
    .pipe(gulp.dest('js'))
    .pipe(connect.reload())
    # .pipe(plugins.notify({message: 'Scripts task complete'}))

gulp.task 'jade', ->
  gulp.src('*.jade')
    .pipe(plumber({
      errorHandler: onError
    }))
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest('.'))
    .pipe(connect.reload())

gulp.task 'html', ->
  gulp.src('*.html')
    .pipe(connect.reload())

gulp.task 'default', [
  'connect'
  'styles'
  'scripts'
  'jade'
  'watch'
]

gulp.task 'watch', ->
  gulp.watch('*.html', ['html'])
  gulp.watch('sass/*.sass', ['styles'])
  gulp.watch('coffee/*.coffee', ['scripts'])
  gulp.watch('*.jade', ['jade'])
