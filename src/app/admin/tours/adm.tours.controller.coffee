angular.module("voyageVoyage").controller "AdminToursController",
($scope, $q, ImageUploadService, TourStateFactory, FakerFactory, Entity,
TourRepository, HotelRepository, CountryRepository, PlaceRepository, toastr, _) ->
  UNSAVED_CHANGES_WARNING = "Есть несохраненные изменения. Продолжить?"
  REMOVE_WARNING = "Удалить тур?"

  promises = {
    tours: TourRepository.all().$promise
    places: PlaceRepository.all().$promise
    countries: CountryRepository.all().$promise
    hotels: HotelRepository.all().$promise }

  $q.all(promises)
    .then (data) ->
      $scope.tours = data.tours
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
    TourRepository.save($scope.tour).then ->
      toastr.success('Tour saved')
      if $scope.image
        $scope.upload($scope.image, $scope.tour).then (response) ->
          TourRepository.save($scope.tour)
          toastr.success('Image attached')
          $scope.setState('browse')
      else
        $scope.setState('browse')
    
  $scope.update = ->
    $scope.tour.commitChanges()
    TourRepository.save($scope.tour).then ->
      toastr.success('Saved successfully')
    $scope.setState('browse')

  $scope.cancel = ->
    if $scope.state.canCancel() or confirm(UNSAVED_CHANGES_WARNING)
      $scope.tour.rejectChanges()
      $scope.setState('browse')

  $scope.remove = (tour) ->
    if confirm(REMOVE_WARNING)
      TourRepository.remove(tour).then ->
        toastr.success('Removed successfully')
      
  $scope.upload = (file) ->
    ImageUploadService.uploadImage(file, $scope.tour).then (response) ->
      TourRepository.addImage($scope.tour, response.data.name, response.data.url).then ->
        toastr.success 'Ok'

  $scope.seedDb = ->
    countries = Entity.fromArray FakerFactory.countries
    angular.forEach countries, (country) ->
      PersistenceService.saveResource('country', country)

    places = Entity.fromArray FakerFactory.places($scope.countries)
    angular.forEach places, (place) ->
      PersistenceService.saveResource('place', place)
      
    hotels = Entity.fromArray FakerFactory.hotels
    angular.forEach hotels, (hotel) ->
      PersistenceService.saveResource('hotel', hotel)

    tours = Entity.fromArray FakerFactory.tours(20, { countries: $scope.countries, places: $scope.places, hotels: $scope.hotels })
    angular.forEach tours, (tour) ->
      PersistenceService.saveResource('tour', tour)
    alert 'Seed finished'

  $scope.getCountryById = (countryId) ->
    found = _.find $scope.countries, (country) -> country.objectId == countryId
    _.result(found, 'name', 'n/a')
    
  $scope.getPlaceById = (placeId) ->
    found = _.find $scope.places, (place) -> place.objectId == placeId
    _.result(found, 'name', 'n/a')
    
  $scope.getHotelById = (hotelId) ->
    found = _.find $scope.hotels, (hotel) -> hotel.objectId == hotelId
