angular.module('voyageVoyage')
  .controller 'ToursController', ($scope, TourRepository, PlaceRepository, CountryRepository, HotelRepository,
  Entity, _, ToursFilterService, toastr) ->

    $scope.itemsOnPage = 5

    $scope.setPage = (page) ->
      $scope.currentPage = page
      $scope.pageBeginIndex = $scope.itemsOnPage * (page - 1)
      
    TourRepository.all().$promise.then ->
      $scope.tours = TourRepository.tours
      $scope.countries = CountryRepository.all()
      $scope.hotels = HotelRepository.all()
      $scope.places = PlaceRepository.all()
      $scope.setPage(1)

    $scope.countryFilter = (tour) -> ToursFilterService.countryFilter(tour, $scope.selectedCountry)
    $scope.placeFilter = (tour) -> ToursFilterService.placeFilter(tour, $scope.selectedPlace)
    $scope.starsFilter = (tour) -> ToursFilterService.starsFilter(tour, $scope.hotels, $scope.selectedStars)

    # reset the pager when the filter changes
    $scope.filterChanged = ->
      $scope.pageBeginIndex = 0
      $scope.currentPage = 1

    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.objectId == countryId
      _.result(found, 'name', 'n/a')
      
    $scope.getPlaceById = (placeId) ->
      found = _.find $scope.places, (place) -> place.objectId == placeId
      _.result(found, 'name', 'n/a')
      
    $scope.getHotelById = (hotelId) ->
      found = _.find $scope.hotels, (hotel) -> hotel.objectId == hotelId
