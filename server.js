'use strict';

//- --------- REQUIREMENTS

var express = require('express');
var path = require('path');
var serveStatic = require('serve-static');
var cfg = require('./gulp/config');

//- --------- CONFIGS
var app = express();
var port = process.env.PORT || cfg.port;

app.use(serveStatic(path.join(__dirname, cfg.dir_library, '')));

function run() {
  app.listen(port, function(){});
}

if (module.parent) {
  module.exports.run = run;
} else {
  run();
}