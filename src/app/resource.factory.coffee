angular.module('voyageVoyage').factory 'ResourceFactory', ['$resource', ($resource) ->
  (resourceName) ->
    console.log resourceName
    url = "https://api.parse.com/1/classes/#{resourceName}/:objectId"
    console.log url
    res = $resource url,
      {objectId: '@objectId' },
      {query:
        {
          isArray: true,
          transformResponse: (data, headersGetter) -> angular.fromJson(data).results }
      'update':
        { method: 'PUT' } }
]
