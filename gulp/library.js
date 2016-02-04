'use strict';

//- --------- REQUIREMENTS

var cfg = require('./config');
var g = require('gulp');
var jsonfy = require('gulp-file-contents-to-json');
var rename = require('gulp-rename');
var renamex = require('gulp-regex-rename');
var replace = require('gulp-batch-replace');
var jsonminify  = require('gulp-jsonminify');
var notify = require("gulp-notify");
var debug = require('gulp-debug');

//- --------- CONFIGS

var replacements = [[/(?:\/\*(?:[\s\S]*?)\*\/)|(?:(([\s;])|^\s*)+\/\/(?:.*)$)/gm, '']];

//- --------- TASKS

g.task('library', function() {
  return g.src(cfg.m.src)
    .pipe(debug({title: 'library-debug:'}))
    .pipe(rename({
      dirname: '',
      extname: ''
    }))
    .pipe(renamex(/^_(?!\.m)/, ''))
    .pipe(replace(replacements))
    .pipe(jsonfy(cfg.file_library_dev))
    .pipe(rename({extname: '.json'}))
    .pipe(jsonminify())
    .pipe(g.dest(cfg.m.dest))
    ;
});