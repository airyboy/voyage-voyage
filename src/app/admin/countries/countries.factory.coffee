angular.module('voyageVoyage').factory 'CountryDbFactory', ['$resource', ($resource) ->
  CountryDb = $resource 'https://api.parse.com/1/classes/country/:objectId',
    {objectId: '@objectId' },
    {query: { isArray: true, transformResponse: parseResults }, 'update': { method: 'PUT' } }
]
