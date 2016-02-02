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

    scope.$watch 'places.length', (newVal) ->
      scope.placesFiltered = scope.places if newVal > 0

    scope.onFilterChanged = ->
      scope.placesFiltered = scope.places.filter (place) ->
        if scope.selectedCountry then place.countryId == scope.selectedCountry.objectId else true
      scope.filterChangedCallback()

    scope.reset = ->
      scope.selectedStars = null
      scope.selectedCountry = null
      scope.selectedPlace = null
      scope.placesFiltered = scope.places

    scope.$on 'filter.country', (e, args) ->
      scope.filterChangedCallback()
      # Not very good. I create an object that pretends to be of Entity type by exposing only an id field
      # but I do this in attempt to avoid excessive usage of two way binding
      scope.selectedCountry = {objectId: args.id}

    scope.$on 'filter.place', (e, args) ->
      scope.filterChangedCallback()
      scope.selectedPlace = {objectId: args.id}

angular.module('voyageVoyage').directive 'vvFilterReset', ->
  restrict: 'A'
  require: '^vvToursFilter'
  link: (scope, element, attrs, controller) ->
    element.on 'click', ->
      scope.$apply -> controller.reset()


angular.module('voyageVoyage').directive 'vvTourLinkFilter', ['$rootScope', ($rootScope) ->
  restrict: 'E'
  template: "<span class='label label-success' style='cursor: pointer;'>{{ text }}</span>"
  scope:
    id: '@'
    text: '@'
    type: '@'
  link: (scope, iElement, iAttr) ->
    iElement.on 'click', ->
      scope.$apply ->
        $rootScope.$broadcast "filter.#{scope.type}", { id: scope.id } ]
