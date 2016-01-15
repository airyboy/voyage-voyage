angular.module('voyageVoyage').controller 'PlacesController',
  ($scope, $q, PlaceRepository, CountryRepository, SimpleStateFactory, Entity) ->
    
    $scope.setState = (state, idx, place) ->
      $scope.state = new SimpleStateFactory('place', state, place, idx)
      
    promises = {
      places: PlaceRepository.all().$promise,
      countries: CountryRepository.all().$promise }

    $q.all(promises).then (data) ->
      $scope.places = Entity.fromArray(data.places)
      $scope.countries = data.countries
      $scope.setState('browse')

    $scope.add = ->
      PlaceRepository.save($scope.state.place)
      $scope.push $scope.state.place
      $scope.setState('browse')

    $scope.update = ->
      PlaceRepository.save($scope.state.place).then (resp) ->
        console.log resp
        $scope.setState('browse')

    $scope.cancelEdit = ->
      $scope.place.rejectChanges()
      $scope.setState('browse')

    $scope.remove = (idx) ->
      if confirm("Удалить?")
        place = $scope.places[idx]
        PlaceRepository.remove(place)
        $scope.places.splice(idx, 1)

    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.objectId == countryId
      found.name
