angular.module('voyageVoyage')
  .controller 'ToursController', ($scope, $q, PersistenceService, _) ->

    loadPlaces = -> PersistenceService.loadResource('place').$promise
    loadCountries = -> PersistenceService.loadResource('country').$promise
    loadHotels = -> PersistenceService.loadResource('hotel').$promise
    load = -> PersistenceService.loadResource('tour').$promise
    
    allPlaces = []

    promises = { tours: load(), places: loadPlaces(), countries: loadCountries(), hotels: loadHotels() }
    $q.all(promises).then (data) ->
      console.log data
      $scope.tours = data.tours
      $scope.countries = data.countries
      $scope.hotels = data.hotels
      allPlaces = data.places
      $scope.places = allPlaces

    $scope.countryFilter = (tour) ->
      if $scope.selectedCountry
        tour.countryId == $scope.selectedCountry.objectId
      else
        true

    $scope.placeFilter = (tour) ->
      if $scope.selectedPlace
        tour.placeId == $scope.selectedPlace.objectId
      else
        true
        
    $scope.shortenText = (text) ->
      "#{text.substring(0, 350)}..."

    $scope.updatePlaceList = ->
      if $scope.selectedCountry
        $scope.places = _.where allPlaces, { countryId: $scope.selectedCountry.objectId }
      else
        $scope.places = allPlaces

    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.objectId == countryId
      found.name || 'n/a'
      
    $scope.getPlaceById = (placeId) ->
      found = _.find $scope.places, (place) -> place.objectId == placeId
      found.name || 'n/a'
      
    $scope.getHotelById = (hotelId) ->
      found = _.find $scope.hotels, (hotel) -> hotel.objectId == hotelId
