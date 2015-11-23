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

var templ = fs.readFileSync('repository.template', 'utf8');
var compiled = _.template(templ);
var js = compiled({ nameSingular: nameSingular, namePlural: namePlural });

var fileName = nameSingular + '.repo.coffee'; 
fs.writeFile(fileName, js); 

console.log("Generated file: %s", fileName);
