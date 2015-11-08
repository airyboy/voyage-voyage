angular.module('voyageVoyage')
  .controller 'ToursController', ($scope, $q, PersistenceService, Entity, _, ToursFilterService, FakerFactory) ->

    allPlaces = []
    allTours = []
    $scope.itemsOnPage = 4

    promises =
      tours: PersistenceService.loadResource('tour').$promise
      places: PersistenceService.loadResource('place').$promise
      countries: PersistenceService.loadResource('country').$promise
      hotels: PersistenceService.loadResource('hotel').$promise

    $q.all(promises).then (data) ->
      $scope.countries = data.countries
      $scope.hotels = data.hotels
      allPlaces = data.places
      allTours = data.tours
      $scope.tours = allTours
      $scope.places = allPlaces
      $scope.toursCount = allTours.length
      $scope.setPage(1)
      
    $scope.countryFilter = (tour) -> ToursFilterService.countryFilter(tour, $scope.selectedCountry)
    $scope.placeFilter = (tour) -> ToursFilterService.placeFilter(tour, $scope.selectedPlace)
    $scope.updatePlaceList = ->
      $scope.places = ToursFilterService.placesFilteredByCountry(allPlaces, $scope.selectedCountry)
        
    $scope.setPage = (page) ->
      $scope.currentPage = page
      $scope.pageBeginIndex = $scope.itemsOnPage * (page - 1)

    $scope.filterChanged = ->
      console.log $scope.selectedCountry

    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.objectId == countryId
      _.result(found, 'name', 'n/a')
      
    $scope.getPlaceById = (placeId) ->
      found = _.find allPlaces, (place) -> place.objectId == placeId
      _.result(found, 'name', 'n/a')
      
    $scope.getHotelById = (hotelId) ->
      found = _.find $scope.hotels, (hotel) -> hotel.objectId == hotelId
