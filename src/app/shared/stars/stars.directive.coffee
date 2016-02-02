angular.module('voyageVoyage').directive 'vvStars', ['_', (_) ->
  restrict: 'E'
  templateUrl: 'app/shared/stars/stars.html'
  scope:
    stars: '@'
  link: (scope, iElement, iAttr) ->
    scope.times = (n) ->
      [1..n]
]
