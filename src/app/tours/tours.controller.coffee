angular.module('voyageVoyage')
  .controller 'ToursController', ($scope, $q, PersistenceService, _) ->
    loadPlaces = ->
      deffered = $q.defer()
      PersistenceService.loadResource('place').$promise
        .then (response) ->
          deffered.resolve(response)
      deffered.promise
      
    loadCountries = ->
      deffered = $q.defer()
      PersistenceService.loadResource('country').$promise
        .then (response) ->
          deffered.resolve(response)
      deffered.promise

    load = ->
      deffered = $q.defer()
      PersistenceService.loadResource('tour').$promise
        .then (response) ->
          deffered.resolve(response)
      deffered.promise

    promises = { tours: load(), places: loadPlaces(), countries: loadCountries() }
    $q.all(promises).then (data) ->
      console.log data
      $scope.tours = data.tours
      $scope.countries = data.countries
      $scope.places = data.places

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

    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.objectId == countryId
      if found.name
        found.name
      else
        'n/a'
      
    $scope.getPlaceById = (placeId) ->
      found = _.find $scope.places, (place) -> place.objectId == placeId
      if found
        found.name
      else
        'n/a'
