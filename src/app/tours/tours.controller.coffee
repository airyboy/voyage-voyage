angular.module('voyageVoyage')
  .controller 'ToursController', ($scope, PersistenceService, _) ->
    do ->
      $scope.tours = PersistenceService.load()
      $scope.countries = PersistenceService.countriesDefault()
      $scope.selectedCountry = null

    $scope.countryFilter = (tour) ->
      if $scope.selectedCountry
        tour.countryId == $scope.selectedCountry.id
      else
        true

    $scope.shortenText = (text) ->
      "#{text.substring(0, 350)}..."

    $scope.getCountryById = (countryId) ->
      found = _.find $scope.countries, (country) -> country.id == countryId
      found.name
