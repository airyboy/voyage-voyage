angular.module('voyageVoyage') .controller 'TourController',
($scope, $stateParams, TourRepository, PlaceRepository, CountryRepository, HotelRepository) ->

  TourRepository.getById($stateParams.id).$promise.then (tour) ->
    $scope.tour = tour
    $scope.country = CountryRepository.getById(tour.countryId)
    $scope.hotel = HotelRepository.getById(tour.hotelId)
    $scope.place = PlaceRepository.getById(tour.placeId)
