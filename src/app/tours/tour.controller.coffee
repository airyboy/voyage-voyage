angular.module('voyageVoyage') .controller 'TourController',
($scope, $routeParams, $q,  PersistenceService, TourRepository, PlaceRepository, CountryRepository, HotelRepository, _) ->

  TourRepository.getById($routeParams.slug).$promise.then (tour) ->
    $scope.tour = tour
    $scope.country = CountryRepository.getById(tour.countryId)
    $scope.hotel = HotelRepository.getById(tour.hotelId)
    $scope.place = PlaceRepository.getById(tour.placeId)


  #loadDependencies = (countryId, hotelId, placeId) ->
    #$q.all({
      #country: PersistenceService.loadResourceById('country', countryId).$promise,
      #place: PersistenceService.loadResourceById('place', placeId).$promise,
      #hotel: PersistenceService.loadResourceById('hotel', hotelId).$promise })

  #PersistenceService.loadResourceById('tour', $routeParams.slug).$promise
    #.then (tour) ->
      #loadDependencies(tour.countryId, tour.hotelId, tour.placeId)
        #.then (result) ->
          #$scope.country = result.country
          #$scope.hotel = result.hotel
          #$scope.place = result.place
          #$scope.tour = tour
    #.catch (err) ->
      #console.log err
