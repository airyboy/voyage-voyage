angular.module("voyageVoyage").controller "HotelsController", ($scope, $q, $resource, PersistenceService, ResourceFactory, _) ->
  Hotel = $resource "https://api.parse.com/1/classes/hotel/:objectId",
    {objectId: '@objectId' },
    {query:
      {
        isArray: true,
        transformResponse: (data, headersGetter) -> angular.fromJson(data).results }
    'update': { method: 'PUT' }
    'getById': { method: 'GET', isArray: false } }

  Hotel.query().$promise.then (response) ->
    $scope.hotels = response



