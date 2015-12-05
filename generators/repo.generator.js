'use strict';
var fs = require('fs');
var _ = require('lodash');
var commandLineArgs = require('command-line-args');

var Console = require('console').Console;
var output = fs.createWriteStream('./stdout.log');
var logger = new Console(output);

var cli = commandLineArgs([
    { name: 'class', alias: 'c', type: String },
    { name: 'plural', alias: 'p', type: String }
]);

var options = cli.parse();
var nameSingular = options.class;
var namePlural = options.plural || nameSingular + 's';
var nameCapitalized = nameSingular[0].toUpperCase() + nameSingular.slice(1);

var repoTemplate = fs.readFileSync('repository.template', 'utf8');
var specTemplate = fs.readFileSync('repository.spec.template', 'utf8');
var compiledRepo = _.template(repoTemplate);
var compiledSpec = _.template(specTemplate);

var repo = compiledRepo({ 
  nameSingular: nameSingular,
  namePlural: namePlural,
  nameCapitalized: nameCapitalized });

var spec = compiledSpec({ 
  nameSingular: nameSingular,
  namePlural: namePlural,
  nameCapitalized: nameCapitalized });

var repoFileName = nameSingular + '.repo.coffee'; 
var specFileName = nameSingular + '.repo.spec.coffee'; 
fs.writeFile(repoFileName, repo); 
fs.writeFile(specFileName, spec); 

console.log("Generated file: %s", repoFileName);
console.log("Generated file: %s", specFileName);
