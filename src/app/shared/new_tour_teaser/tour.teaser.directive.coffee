angular.module('voyageVoyage').directive 'vvTourTeaser', ->
  restrict: 'E'
  templateUrl: 'app/shared/new_tour_teaser/tour.teaser.html'
  scope: {}
  link: (scope, iElement, iAttr) ->
    scope.$on 'tour.new', (e, args) ->
      scope.$apply ->
        scope.tour = args.tour
