angular.module('voyageVoyage')
  .controller 'ToursController', ($scope, PersistenceService, _) ->
    $scope.title = 'Tours'

    do ->
      $scope.tours = PersistenceService.load()
      $scope.countries = PersistenceService.countriesDefault()
      $scope.selectedCountry = null

    $scope.countryFilter = (tour) ->
      console.log $scope.selectedCountry
      if $scope.selectedCountry
        tour.country == $scope.selectedCountry.name
      else
        true

    $scope.shortenText = (text) ->
      "#{text.substring(0, 350)}..."

    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.id == countryId
      found.name
