angular.module('voyageVoyage').directive 'vvStars', ['_', (_) ->
  restrict: 'E'
  templateUrl: 'app/shared/stars/stars.html'
  scope:
    stars: '@'
    readOnly: '@'
  link: (scope, iElement, iAttr) ->
    scope.elementId = _.uniqueId('star')
    scope.times = (n) ->
      [1..n]

    scope.setStar = (stars) ->
      scope.stars = stars
      console.log stars
]
