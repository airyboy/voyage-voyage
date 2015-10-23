angular.module("voyageVoyage").controller "AdminToursController", ($scope, $q, TourPersistence, PersistenceService, ResourceFactory, _) ->
  UNSAVED_CHANGES_WARNING = "Есть несохраненные изменения. Продолжить?"
  REMOVE_WARNING = "Удалить тур?"
  #=require tours.states.coffee
  #=require tour.coffee

  $scope.tours = []
  $scope.countries = []
  $scope.places = []
  
  loadPlaces = -> PersistenceService.loadResource('place').$promise
  loadCountries = -> PersistenceService.loadResource('country').$promise
  load = -> PersistenceService.loadResource('tour').$promise

  # для удобства каррируем
  save = (tour) -> PersistenceService.saveResource('tour', tour)
  remove = (tour) -> PersistenceService.removeResource('tour', tour)

  promises = { tours: load(), places: loadPlaces(), countries: loadCountries() }
  $q.all(promises)
    .then (data) ->
      #$scope.tours = ((new Tour).fromJSON(e) for e in data.tours)
      $scope.tours = (Tour.fromJson(e) for e in data.tours)
      $scope.countries = data.countries
      $scope.places = data.places
      console.log data
    .catch (error) ->
      alert(error)

  $scope.setState = (state, tour, idx) ->
    console.log state
    $scope.uiState = switch state
      when 'browse' then new BrowseState
      when 'new' then new NewState
      when 'inlineEdit' then new InlineEditState(tour, idx)
    $scope.tour = $scope.uiState.tour
    console.log $scope.uiState

  $scope.setState('browse')

  $scope.add = ->
    $scope.tours.push(@tour)
    save(@tour)
    $scope.setState("browse")
    
  $scope.update = ->
    $scope.tour.commitChanges()
    save(@tour)
    $scope.setState("browse")

  $scope.cancel = ->
    if $scope.uiState.canCancel()
      $scope.tour.rejectChanges()
      $scope.setState("browse")

  $scope.remove = (idx) ->
    if confirm(REMOVE_WARNING)
      $scope.tours.splice(idx, 1)
      remove(@tour)

  $scope.getCountryById = (countryId) ->
    found = _.find $scope.countries, (country) -> country.objectId == countryId
    if found
      found.name
    else
      'n/a'
    
  $scope.getPlaceById = (placeId) ->
    found = _.find $scope.places, (place) -> place.objectId == placeId
    if found
      found.name
    else
      'n/a'