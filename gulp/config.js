'use strict';

//- --------- REQUIREMENTS
var path = require('path');

//- --------- CONFIGS
var port = 1337;
var dir_projectroot = '';
var dir_library = path.join(dir_projectroot, '/library');

var file_library = 'library.json';
var file_library_dev = 'library-dev.json';

module.exports = {
  port: port,
  dir_projectroot: dir_projectroot,
  dir_library: dir_library,
  file_library: file_library,
  file_library_dev: file_library_dev,

  m: {
    src: [
      path.join(dir_library, '/**/*.m'),
      path.join('!', dir_library, '/**/_*{.m,/**}')
    ],
    dest: dir_library
  }
};