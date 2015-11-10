angular.module('voyageVoyage').directive 'vvToursFilter', ->
  restrict: 'E'
  templateUrl: 'app/shared/tours_filter/tours.filter.html'
  scope:
    places: '='
    countries: '='
    selectedCountry: '='
    selectedPlace: '='
    selectedStars: '='
    filterChangedCallback: '&filterChanged'
  link: (scope, iElement, iAttr) ->
    scope.stars = [{val: 2}, {val: 3}, {val: 4}, {val: 5}]

    scope.onFilterChanged = ->
      scope.filterChangedCallback()

    scope.reset = ->
      scope.selectedStars = null
      scope.selectedCountry = null
      scope.selectedPlace = null
