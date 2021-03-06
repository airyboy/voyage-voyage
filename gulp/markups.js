'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var slim = require('gulp-slim');

var browserSync = require('browser-sync');

var $ = require('gulp-load-plugins')();

gulp.task('markups', function() {
  function renameToHtml(path) {
    path.extname = '.html';
  }

  return gulp.src(path.join(conf.paths.src, '/app/**/*.slim'))
    .pipe(slim({ pretty: true, options: "attr_list_delims={'(' => ')', '[' => ']'}" }))
      .on('error', function(e) { console.log(e); this.emit('end');})
    .pipe($.rename(renameToHtml))
    .pipe(gulp.dest(path.join(conf.paths.tmp, '/serve/app/')))
    .pipe(browserSync.reload({ stream: true }));
});
