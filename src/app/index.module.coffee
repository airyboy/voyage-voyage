angular.module('parse', []).service('Parse', ['$window', ->
  Parse.initialize("sXYBJKAzNLajxXs0SqkpjDmPKSY8eES5c4xOH275", "nuLMfhWkmuKIbOYj00rzzUs7A9T4uYWMC5u45c99")
  Parse
])

angular.module "voyageVoyage", ['ngRoute', 'ngResource', 'underscore',
  'ngFileUpload', 'ngMessages', 'toastr', 'parse', 'ui.bootstrap', 'ui.router']
