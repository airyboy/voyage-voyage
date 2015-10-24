angular.module('voyageVoyage').factory 'ResourceFactory', ['$resource', ($resource) ->
  (resourceName) ->
    res = $resource "https://api.parse.com/1/classes/#{resourceName}/:objectId",
      {objectId: '@objectId' },
      {query:
        {
          isArray: true,
          transformResponse: (data, headersGetter) -> angular.fromJson(data).results }
      'update': { method: 'PUT' }
      'getById': { method: 'GET', isArray: false } }
]
