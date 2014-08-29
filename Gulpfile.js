var gulp = require('gulp'),
  autoprefixer = require('gulp-autoprefixer'),
  coffee = require('gulp-coffee'),
  connect = require('gulp-connect'),
  jade = require('gulp-jade'),
  plumber = require('gulp-plumber'),
  sass = require('gulp-ruby-sass')
;

var onError = function(err){
  console.log(err);
};

gulp.task('connect', function(){
  return connect.server({
    root: '',
    livereload: true
  });
});

// TODO: Minify CSS
gulp.task('sass', function(){
  return gulp.src('./sass/*.sass')
    .pipe(plumber({
      errorHandler: onError
    }))
    .pipe(sass({
      style: 'expanded'
    }))
    .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 7', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
    .pipe(gulp.dest('./css'))
    .pipe(connect.reload());
});

// TODO: Minify JS
gulp.task('coffee', function(){
  return gulp.src('./coffee/*.coffee')
    .pipe(plumber({
      errorHandler: onError
    }))
    .pipe(coffee())
    .pipe(gulp.dest('./js'))
    .pipe(connect.reload());
});

gulp.task('jade', function(){
  return gulp.src('*.jade')
    .pipe(plumber({
      errorHandler: onError
    }))
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest('.'))
    .pipe(connect.reload());
});

gulp.task('html', function(){
  return gulp.src('*.html')
    .pipe(connect.reload());
});

gulp.task('watch', function(){
  gulp.watch('*.html', ['html']);
  gulp.watch('sass/*.sass', ['sass']);
  gulp.watch('coffee/*.coffee', ['coffee']);
  gulp.watch('*.jade', ['jade']);
});

gulp.task('default', [
  'connect',
  'sass',
  'coffee',
  'jade',
  'watch'
]);
