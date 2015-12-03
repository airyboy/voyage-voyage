angular.module('voyageVoyage').directive 'vvToursFilter', ->
  restrict: 'E'
  templateUrl: 'app/shared/tours_filter/tours.filter.html'
  transclude: true
  scope:
    places: '='
    countries: '='
    selectedCountry: '='
    selectedPlace: '='
    selectedStars: '='
    filterChangedCallback: '&filterChanged'
  controller: ['$scope', ($scope) ->
    @reset = ->
      $scope.reset()
    return
  ]
  link: (scope, iElement, iAttr) ->
    scope.stars = [{val: 2}, {val: 3}, {val: 4}, {val: 5}]

    scope.onFilterChanged = ->
      scope.filterChangedCallback()

    scope.reset = ->
      scope.selectedStars = null
      scope.selectedCountry = null
      scope.selectedPlace = null

angular.module('voyageVoyage').directive 'vvFilterReset', ->
  restrict: 'A'
  require: '^vvToursFilter'
  link: (scope, element, attrs, controller) ->
    console.log controller
    element.on 'click', ->
      scope.$apply -> controller.reset()
