angular.module('voyageVoyage').controller 'CountriesController',
  ($scope, PersistenceService, Entity, SimpleStateFactory, CRUDService, ImageUploadService) ->
    $scope.file = null
   
    $scope.setState = (state, idx, country) ->
      $scope.state = new SimpleStateFactory('country', state, country, idx)
    
    PersistenceService.loadResource('country').$promise.then (data) ->
      $scope.countries = Entity.fromArray(data)
      $scope.setState('browse')

    $scope.add = -> CRUDService.add('country', $scope.state.country, $scope.countries, $scope.setState)
    $scope.update = -> CRUDService.update('country', $scope.state.country, $scope.setState)
    $scope.cancelEdit = -> CRUDService.cancelEdit($scope.state.country, $scope.setState)
    $scope.remove = (idx) -> CRUDService.remove('country', idx, $scope.countries) if confirm("Удалить?")

    $scope.upload = (file) -> ImageUploadService.uploadImage(file, $scope.state.country)
