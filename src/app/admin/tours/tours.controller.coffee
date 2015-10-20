angular.module("voyageVoyage").controller "AdminToursController", ($scope, PersistenceService, _) ->
  UNSAVED_CHANGES_WARNING = "Есть несохраненные изменения. Продолжить?"
  REMOVE_WARNING = "Удалить тур?"
  #=require tours.states.coffee
  #=require tour.coffee

  $scope.setState = (state, tour, idx) ->
    console.log state
    $scope.uiState = switch state
      when 'browse' then new BrowseState
      when 'new' then new NewState
      when 'inlineEdit' then new InlineEditState(tour, idx)
    $scope.tour = $scope.uiState.tour
    console.log $scope.uiState

  $scope.setState('browse')

  do ->
    json = PersistenceService.load()
    $scope.tours = ((new Tour).fromJSON(e) for e in json)
    $scope.countries = PersistenceService.countriesDefault()

  $scope.add = ->
    $scope.tours.push(this.tour)
    PersistenceService.save($scope.tours)
    $scope.setState("browse")
    
  $scope.update = ->
    $scope.tour.commitChanges()
    PersistenceService.save($scope.tours)
    $scope.setState("browse")

  $scope.cancel = ->
    if $scope.uiState.canCancel()
      $scope.tour.rejectChanges()
      $scope.setState("browse")

  $scope.remove = (idx) ->
    if confirm(REMOVE_WARNING)
      $scope.tours.splice(idx, 1)
      PersistenceService.save($scope.tours)

  $scope.getCountryById = (countryId) ->
    found = _.find $scope.countries, (country) -> country.id == countryId
    found.name
