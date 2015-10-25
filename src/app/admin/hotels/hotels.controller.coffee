angular.module("voyageVoyage").controller "HotelsController",
($scope, PersistenceService, Entity, HotelStateFactory) ->

  # для удобства каррируем
  load = -> PersistenceService.loadResource('hotel').$promise
  save = (hotel) -> PersistenceService.saveResource('hotel', hotel)
  remove = (hotel) -> PersistenceService.removeResource('hotel', hotel)
  
  load().then (response) ->
    $scope.hotels = Entity.fromArray(response)

  $scope.setState = (state, idx, hotel) ->
    $scope.state = new HotelStateFactory(state, hotel, idx)
    
  $scope.state = $scope.setState('browse')

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
      remove(place)
      $scope.places.splice(idx, 1)
    
