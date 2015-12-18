angular.module('voyageVoyage').directive 'vvStarRating', ['_', (_) ->
  restrict: 'E'
  require: '?ngModel'
  templateUrl: 'app/shared/star_rating/star.rating.html'
  scope:
    model: '=ngModel'
  link: (scope, iElement, iAttr, modelController) ->
    scope.times = (n) ->
      [1..n]

    scope.$watch 'model', (newValue) ->
      scope.stars = if newValue then newValue.val else 0

    modelController.$parsers.push((viewValue) ->
      if viewValue > 0 then { val: viewValue } else null
    )

    scope.reset = ->
      modelController.$setViewValue(0)
      scope.stars = 0

    scope.setStar = (stars) ->
      modelController.$setViewValue(stars)
]
