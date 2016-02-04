'use strict';

//- --------- REQUIREMENTS

var cfg = require('./config');
var g = require('gulp');

//- --------- CONFIGS


//- --------- TASKS
g.task('watch', function() {
  g.watch(cfg.m.src, ['library']);
});