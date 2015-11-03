angular.module("voyageVoyage").controller "AdminToursController",
($scope, $q, ImageUploadService, PersistenceService, TourStateFactory, Entity, _) ->
  UNSAVED_CHANGES_WARNING = "Есть несохраненные изменения. Продолжить?"
  REMOVE_WARNING = "Удалить тур?"

  # для удобства каррируем
  save = (tour) -> PersistenceService.saveResource('tour', tour)
  remove = (tour) -> PersistenceService.removeResource('tour', tour)

  promises = {
    tours: PersistenceService.loadResource('tour').$promise
    places: PersistenceService.loadResource('place').$promise
    countries: PersistenceService.loadResource('country').$promise
    hotels: PersistenceService.loadResource('hotel').$promise }

  $q.all(promises)
    .then (data) ->
      $scope.tours = Entity.fromArray(data.tours)
      $scope.countries = data.countries
      $scope.places = data.places
      $scope.hotels = data.hotels
    .catch (error) ->
      alert(error)

  $scope.setState = (state, tour, idx) ->
    $scope.state = new TourStateFactory(state, tour, idx)
    $scope.tour = $scope.state.tour

  $scope.setState('browse')

  $scope.add = ->
    $scope.tours.push(@tour)
    save(@tour)
    $scope.setState('browse')
    
  $scope.update = ->
    $scope.tour.commitChanges()
    save(@tour)
    $scope.setState('browse')

  $scope.cancel = ->
    if $scope.state.canCancel() or confirm(UNSAVED_CHANGES_WARNING)
      $scope.tour.rejectChanges()
      $scope.setState('browse')

  $scope.remove = (idx) ->
    if confirm(REMOVE_WARNING)
      $scope.tours.splice(idx, 1)
      remove(@tour)
      
  $scope.upload = (file) -> ImageUploadService.uploadImage(file, $scope.tour)

  $scope.getCountryById = (countryId) ->
    found = _.find $scope.countries, (country) -> country.objectId == countryId
    _.result(found, 'name', 'n/a')
    
  $scope.getPlaceById = (placeId) ->
    found = _.find $scope.places, (place) -> place.objectId == placeId
    _.result(found, 'name', 'n/a')
    
  $scope.getHotelById = (hotelId) ->
    found = _.find $scope.hotels, (hotel) -> hotel.objectId == hotelId