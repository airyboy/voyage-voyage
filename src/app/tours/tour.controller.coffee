angular.module('voyageVoyage') .controller 'TourController', ($scope, $routeParams,  PersistenceService, _) ->
  @loadDependencies = ->
    PersistenceService.loadResourceById('country', $scope.tour.countryId).$promise
      .then (country) ->
        $scope.country = country
    PersistenceService.loadResourceById('place', $scope.tour.placeId).$promise
      .then (place) ->
        $scope.place = place

  PersistenceService.loadResourceById('tour', $routeParams.slug).$promise
    .then (tour) =>
      $scope.tour = tour
      @loadDependencies()
