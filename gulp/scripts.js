'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var include = require('gulp-include');

var browserSync = require('browser-sync');

var $ = require('gulp-load-plugins')();

gulp.task('scripts', function () {
  return gulp.src(path.join(conf.paths.src, '/app/**/*.coffee'))
    .pipe($.sourcemaps.init())
    .pipe($.coffeelint())
    .pipe($.coffeelint.reporter())
    .pipe(include('coffee')).on('error', console.log)
    .pipe($.coffee()).on('error', conf.errorHandler('CoffeeScript'))
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest(path.join(conf.paths.tmp, '/serve/app')))
    //.pipe(browserSync.reload({ stream: true }))
    .pipe($.size())
});
