angular.module('voyageVoyage').controller 'PlacesController',
  ($scope, $q, PersistenceService, SimpleStateFactory, Entity) ->
    
    $scope.setState = (state, idx, place) ->
      $scope.state = new SimpleStateFactory('place', state, place, idx)
      
    promises = {
      places: PersistenceService.loadResource('place').$promise,
      countries: PersistenceService.loadResource('country').$promise }

    $q.all(promises).then (data) ->
      $scope.places = Entity.fromArray(data.places)
      $scope.countries = data.countries
      $scope.setState('browse')

    $scope.add = -> CRUDService.add 'place', $scope.state.place, $scope.places, $scope.setState
    $scope.update = -> CRUDService.update 'place', $scope.state.place, $scope.setState
    $scope.cancelEdit = -> CRUDService.cancelEdit $scope.state.place, $scope.setState
    $scope.remove = (idx) -> CRUDService.remove 'place', idx, $scope.places if confirm("Удалить?")

    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.objectId == countryId
      found.name
