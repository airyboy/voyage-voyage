'use strict';

var path = require('path');
var conf = require('./gulp/conf');

var _ = require('lodash');
var wiredep = require('wiredep');

function listFiles() {
  var wiredepOptions = _.extend({}, conf.wiredep, {
    dependencies: true,
    devDependencies: true
  });

  return wiredep(wiredepOptions).js
    .concat([
      //path.join(conf.paths.tmp, '/serve/app/**/*.module.js'),
      //path.join(conf.paths.tmp, '/serve/app/**/*.js'),
      //path.join(conf.paths.tmp, '/partials/**/*.js'),
      path.join(conf.paths.tmp, '/serve/app/**/*.html'),
      //path.join(conf.paths.src, '/**/*.spec.js'),
      //path.join(conf.paths.src, '/**/*.spec.coffee'),
      path.join(conf.paths.src, '/**/*.module.coffee'),
      path.join(conf.paths.src, '/**/*.coffee'),
      path.join(conf.paths.src, 'app/admin/**/*.coffee'),
      path.join(conf.paths.test, '/**/*.coffee'),
      //path.join(conf.paths.src, '/**/*.mock.js'),
      path.join(conf.paths.src, '/**/*.html')
    ]);
}

module.exports = function(config) {

  var configuration = {
    files: listFiles(),

    singleRun: false,

    autoWatch: false,

    frameworks: ['jasmine'],

    angularFilesort: {
      whitelist: [path.join(conf.paths.tmp, '/**/!(*.html|*.spec|*.mock).js')]
    },

    ngHtml2JsPreprocessor: {
      stripPrefix: '.tmp/serve/',
      moduleName: 'vvDirectives'
    },

    coffeePreprocessor: {
      // options passed to the coffee compiler
      options: {
        bare: true,
        sourceMap: true
      },
      // transforming the filenames
      transformPath: function(path) {
        return path.replace(/\.coffee$/, '.js')
      }
    },

    browsers : ['Chrome'],

    plugins : [
      'karma-chrome-launcher',
      'karma-angular-filesort',
      'karma-jasmine',
      'karma-ng-html2js-preprocessor',
      'karma-coffee-preprocessor'
      //'karma-coverage'
    ],

    preprocessors: {
      '.tmp/serve/app/**/*.html': ['ng-html2js'],
      'src/**/*.coffee': ['coffee'],
      //'src/**/*.coffee': ['coverage'],
      'test/**/*.coffee': ['coffee']
    }

    //reporters: ['progress', 'coverage'],

    //coverageReporter: {
      //type: 'html',
      //instrumenters: { ibrik: require('ibrik') },
      //instrumenter: { '**/*.coffee': 'ibrik' },
      //dir: 'coverage/' }
  };

  // This block is needed to execute Chrome on Travis
  // If you ever plan to use Chrome and Travis, you can keep it
  // If not, you can safely remove it
  // https://github.com/karma-runner/karma/issues/1144#issuecomment-53633076
  if(configuration.browsers[0] === 'Chrome' && process.env.TRAVIS) {
    configuration.customLaunchers = {
      'chrome-travis-ci': {
        base: 'Chrome',
        flags: ['--no-sandbox']
      }
    };
    configuration.browsers = ['chrome-travis-ci'];
  }

  config.set(configuration);
};
