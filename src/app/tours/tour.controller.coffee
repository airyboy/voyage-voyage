angular.module('voyageVoyage') .controller 'TourController',
($scope, $routeParams, TourRepository, PlaceRepository, CountryRepository, HotelRepository) ->

  TourRepository.getById($routeParams.slug).$promise.then (tour) ->
    $scope.tour = tour
    $scope.country = CountryRepository.getById(tour.countryId)
    $scope.hotel = HotelRepository.getById(tour.hotelId)
    $scope.place = PlaceRepository.getById(tour.placeId)
