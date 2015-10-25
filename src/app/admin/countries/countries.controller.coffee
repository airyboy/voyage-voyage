#angular.module('voyageVoyage').controller 'CountriesController', ($scope, PersistenceService, $resource) ->
angular.module('voyageVoyage').controller 'CountriesController', ['$scope', '$resource', 'PersistenceService',
  ($scope, $resource, PersistenceService) ->
    #=require country.coffee
    #=require countries.states.coffee

    # для удобства каррируем
    load = -> PersistenceService.loadResource('country')
    save = (country) -> PersistenceService.saveResource('country', country)
    remove = (country) -> PersistenceService.removeResource('country', country)
    
    load().$promise.then (data) ->
      $scope.countries = ((new Country).fromJSON(e) for e in data)
      $scope.state = new BrowseState

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
      
    $scope.setState = (state, idx, country) ->
      $scope.state = switch state
        when 'browse' then new BrowseState
        when 'add' then new NewState
        when 'edit' then new EditState(country, idx)
   ]
