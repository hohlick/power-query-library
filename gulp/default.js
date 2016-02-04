'use strict';

//- --------- REQUIREMENTS

var cfg = require('./config');
var g = require('gulp');

//- --------- CONFIGS


//- --------- TASKS
g.task('default', ['nodemon', 'watch']);