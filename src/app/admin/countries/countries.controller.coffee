angular.module('voyageVoyage').controller 'CountriesController',
  ($scope, PersistenceService, Entity, SimpleStateFactory) ->
    # для удобства каррируем
    load = -> PersistenceService.loadResource('country')
    save = (country) -> PersistenceService.saveResource('country', country)
    remove = (country) -> PersistenceService.removeResource('country', country)
   
    $scope.setState = (state, idx, country) ->
      $scope.state = new SimpleStateFactory('country', state, country, idx)
    
    load().$promise.then (data) ->
      $scope.countries = Entity.fromArray(data)
      $scope.setState('browse')

    $scope.add = ->
      save($scope.state.country)
      $scope.countries.push($scope.state.country)
      $scope.setState 'browse'

    $scope.update = ->
      save($scope.state.country)
      $scope.setState 'browse'
      
    $scope.cancelEdit = ->
      $scope.state.country.rejectChanges()
      $scope.setState 'browse'

    $scope.remove = (idx) ->
      if confirm("Удалить?")
        country = $scope.countries[idx]
        remove(country)
        $scope.countries.splice(idx, 1)
