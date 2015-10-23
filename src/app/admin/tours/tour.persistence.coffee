angular.module('voyageVoyage').factory 'TourPersistence', ['$resource', ($resource) ->
  parseResults = (data, headersGetter) ->
    dt = angular.fromJson(data)
    dt.results
  
  $resource 'https://api.parse.com/1/classes/tour/:objectId',
    {objectId: '@objectId' },
    {query: { isArray: true, transformResponse: parseResults }, 'update': { method: 'PUT' } }
]

