angular.module('voyageVoyage')
  .controller 'ToursController', ($scope, $q, PersistenceService, Entity, _, ToursFilterService, FakerFactory) ->

    loadPlaces = -> PersistenceService.loadResource('place').$promise
    loadCountries = -> PersistenceService.loadResource('country').$promise
    loadHotels = -> PersistenceService.loadResource('hotel').$promise
    load = -> PersistenceService.loadResource('tour').$promise
    

    
    allPlaces = []

    promises = { tours: load(), places: loadPlaces(), countries: loadCountries(), hotels: loadHotels() }
    $q.all(promises).then (data) ->
      $scope.tours = data.tours
      $scope.countries = data.countries
      $scope.hotels = data.hotels
      allPlaces = data.places
      $scope.places = allPlaces
      
    $scope.countryFilter = (tour) -> ToursFilterService.countryFilter(tour, $scope.selectedCountry)
    $scope.placeFilter = (tour) -> ToursFilterService.placeFilter(tour, $scope.selectedPlace)
    $scope.updatePlaceList = ->
      $scope.places = ToursFilterService.placesFilteredByCountry(allPlaces, $scope.selectedCountry)
        
    $scope.shortenText = (text) ->
      "#{text.substring(0, 350)}... "

    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.objectId == countryId
      _.result(found, 'name', 'n/a')
      
    $scope.getPlaceById = (placeId) ->
      found = _.find $scope.places, (place) -> place.objectId == placeId
      _.result(found, 'name', 'n/a')
      
    $scope.getHotelById = (hotelId) ->
      found = _.find $scope.hotels, (hotel) -> hotel.objectId == hotelId
