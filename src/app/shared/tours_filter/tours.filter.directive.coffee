angular.module('voyageVoyage').directive 'vvToursFilter', ->
  restrict: 'E'
  templateUrl: 'app/shared/tours_filter/tours.filter.html'
  scope:
    places: '='
    countries: '='
    selectedCountry: '='
    selectedPlace: '='
    filterChangedCallback: '&filterChanged'
  link: (scope, iElement, iAttr) ->
    scope.onFilterChanged = ->
      scope.filterChangedCallback()
