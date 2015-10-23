angular.module('voyageVoyage').factory 'ResourceFactory', ['$resource', ($resource) ->
  (resourceName) ->
    url = "https://api.parse.com/1/classes/#{resourceName}/:objectId"
    console.log url
    res = $resource url,
      {objectId: '@objectId' },
      {query:
        {
          isArray: true,
          transformResponse: (data, headersGetter) -> angular.fromJson(data).results }
      'update': { method: 'PUT' }
      'getById': { method: 'GET', isArray: false } }
]
