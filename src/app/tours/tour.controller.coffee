angular.module('voyageVoyage') .controller 'TourController', ($scope, $routeParams, $q,  PersistenceService, _) ->
  loadDependencies = (countryId, hotelId, placeId) ->
    $q.all({
      country: PersistenceService.loadResourceById('country', countryId).$promise,
      place: PersistenceService.loadResourceById('place', placeId).$promise,
      hotel: PersistenceService.loadResourceById('hotel', hotelId).$promise })

  PersistenceService.loadResourceById('tour', $routeParams.slug).$promise
    .then (tour) ->
      loadDependencies(tour.countryId, tour.hotelId, tour.placeId)
        .then (result) ->
          $scope.country = result.country
          $scope.hotel = result.hotel
          $scope.place = result.place
          $scope.tour = tour
    .catch (err) ->
      console.log err
