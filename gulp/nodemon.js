'use strict';

//- --------- REQUIREMENTS

var cfg = require('./config');
var g = require('gulp');
var nodemon = require('gulp-nodemon');

//- --------- CONFIGS
var delay = 500;
var nodemon_cfg = {
  script: ['./server.js'],
  tasks: ['watch', 'library'],
  ext: 'json m',
  env: {
    'NODE_ENV': 'development',
    'PORT': cfg.port
  },
  watch: [
    'server.js',
    'gulpfile.js',
    'gulp/default.js',
    'gulp/nodemon.js',
    'gulp/library.js',
    'gulp/watch.js',
    'gulp/config.js'
  ],
  ignore: [
    '.git',
    'node_modules',
    'bower_components',
    '.idea',
    'log'
  ]
};

//- --------- TASKS

g.task('nodemon', function(cb) {
  var called, started;
  called = false;
  started = false;
  return nodemon(nodemon_cfg)
    .on('start', function() {
      if (!called) {
        cb();
        started = true;
      }
      called = true;
      console.log('Nodemon started!')
    })
    .on('restart', function() {
      setTimeout((function() {
        console.log('Nodemon restarted!');
        //bs.reload({
        //  stream: false
        //});
      }), delay);
    });
});