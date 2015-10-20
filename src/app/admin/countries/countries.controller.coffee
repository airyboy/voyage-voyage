angular.module('voyageVoyage').controller 'CountriesController', ($scope, PersistenceService) ->
  #=require country.coffee
  #=require countries.states.coffee
  
  do ->
    json = PersistenceService.countriesDefault()
    $scope.countries = ((new Country).fromJSON(e) for e in json)
    $scope.state = new BrowseState

  $scope.add = (country) ->
    $scope.countries.push($scope.state.country)
    $scope.setState 'browse'

  $scope.update = ->
    $scope.state.country.commitChanges()
    $scope.setState 'browse'
    
  $scope.cancelEdit = ->
    $scope.state.country.rejectChanges()
    $scope.setState 'browse'

  $scope.remove = (idx) ->
    if confirm("Удалить?")
      $scope.countries.splice(idx)
    
  $scope.setState = (state, idx, country) ->
    $scope.state = switch state
      when 'browse' then new BrowseState
      when 'add' then new NewState
      when 'edit' then new EditState(country, idx)
