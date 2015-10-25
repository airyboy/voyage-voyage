angular.module('voyageVoyage').controller 'PlacesController',
  ($scope, $q, PersistenceService, SimpleStateFactory, Entity) ->

    loadCountries = -> PersistenceService.loadResource('country').$promise
    load = -> PersistenceService.loadResource('place').$promise

    # для удобства каррируем
    save = (place) -> PersistenceService.saveResource('place', place)
    remove = (place) -> PersistenceService.removeResource('place', place)
    
    $scope.setState = (state, idx, place) ->
      $scope.state = new SimpleStateFactory('place', state, place, idx)
      
    promises = { places: load(), countries: loadCountries() }
    $q.all(promises).then (data) ->
      $scope.places = Entity.fromArray(data.places)
      $scope.countries = data.countries
      $scope.setState('browse')

    $scope.add = ->
      save($scope.state.place)
      $scope.places.push($scope.state.place)
      $scope.setState 'browse'

    $scope.update = ->
      save($scope.state.place)
      $scope.state.place.commitChanges()
      $scope.setState 'browse'
      
    $scope.cancelEdit = ->
      $scope.state.place.rejectChanges()
      $scope.setState 'browse'

    $scope.remove = (idx) ->
      if confirm("Удалить?")
        place = $scope.places[idx]
        console.log place
        remove(place)
        $scope.places.splice(idx, 1)
      
    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.objectId == countryId
      found.name || 'n/a'
