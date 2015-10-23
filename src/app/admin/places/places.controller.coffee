angular.module('voyageVoyage').controller 'PlacesController', ['$scope', '$resource', 'PersistenceService', '$q',
  ($scope, $resource, PersistenceService, $q) ->
    #=require place.coffee
    #=require places.states.coffee

    loadCountries = ->
      deffered = $q.defer()
      PersistenceService.loadResource('country').$promise
        .then (response) ->
          deffered.resolve(response)
      deffered.promise

    load = ->
      deffered = $q.defer()
      PersistenceService.loadResource('place').$promise
        .then (response) ->
          deffered.resolve(response)
      deffered.promise

    # для удобства каррируем
    save = (place) -> PersistenceService.saveResource('place', place)
    remove = (place) -> PersistenceService.removeResource('place', place)

    promises = { places: load(), countries: loadCountries() }
    $q.all(promises).then (data) ->
      $scope.places = ((new Place).fromJSON(e) for e in data.places)
      $scope.countries = data.countries
      $scope.state = new BrowsePlaceState

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
        remove($scope.state.place)
        place = $scope.places[idx]
        $scope.places.splice(idx)
      
    $scope.setState = (state, idx, place) ->
      $scope.state = switch state
        when 'browse' then new BrowsePlaceState
        when 'add' then new NewPlaceState
        when 'edit' then new EditPlaceState(place, idx)
   ]
