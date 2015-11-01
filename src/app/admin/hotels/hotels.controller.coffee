angular.module("voyageVoyage").controller "HotelsController",
($scope, PersistenceService, Entity, SimpleStateFactory, CRUDService) ->
  # для удобства каррируем
  load = -> PersistenceService.loadResource('hotel').$promise
  
  load().then (response) ->
    $scope.hotels = Entity.fromArray(response)

  $scope.setState = (state, idx, hotel) ->
    $scope.state = new SimpleStateFactory('hotel', state, hotel, idx)
    
  $scope.state = $scope.setState('browse')

  $scope.add = -> CRUDService.add 'hotel', $scope.state.hotel, $scope.hotels, $scope.setState
  $scope.update = -> CRUDService.update 'hotel', $scope.state.hotel, $scope.setState
  $scope.cancelEdit = -> CRUDService.cancelEdit $scope.state.hotel, $scope.setState
  $scope.remove = (idx) -> CRUDService.remove 'hotel', idx, $scope.countries if confirm("Удалить?")
