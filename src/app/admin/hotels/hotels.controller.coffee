angular.module("voyageVoyage").controller "HotelsController",
($scope, PersistenceService, Entity, SimpleStateFactory) ->

  # для удобства каррируем
  load = -> PersistenceService.loadResource('hotel').$promise
  save = (hotel) -> PersistenceService.saveResource('hotel', hotel)
  remove = (hotel) -> PersistenceService.removeResource('hotel', hotel)
  
  load().then (response) ->
    $scope.hotels = Entity.fromArray(response)

  $scope.setState = (state, idx, hotel) ->
    $scope.state = new SimpleStateFactory('hotel', state, hotel, idx)
    
  $scope.state = $scope.setState('browse')

  $scope.add = ->
    save($scope.state.hotel)
    $scope.hotels.push($scope.state.hotel)
    $scope.setState 'browse'

  $scope.update = ->
    save($scope.state.hotel)
    $scope.state.hotel.commitChanges()
    $scope.setState 'browse'
    
  $scope.cancelEdit = ->
    $scope.state.hotel.rejectChanges()
    $scope.setState 'browse'

  $scope.remove = (idx) ->
    if confirm("Удалить?")
      place = $scope.hotels[idx]
      remove(hotel)
      $scope.hotels.splice(idx, 1)
