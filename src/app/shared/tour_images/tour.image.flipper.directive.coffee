angular.module('voyageVoyage').directive 'vvTourImageFlipper', ->
  restrict: 'E'
  template: "<div class='tour-images'>" +
    "<img height='130' width='230' src='http://placehold.it/230x130?text=No+image' ng-show='images.length == 0'>" +
    "<div class='image' ng-transclude></div>" +
    "</div>"
  transclude: true
  scope: {}
  controller: ['$scope', '_', ($scope, _) ->
    $scope.images = []
    @addImage = (image) ->
      image.current = true if $scope.images.length == 0
      $scope.images.push(image)
    @next = ->
      $scope.next()
    return
  ]
  link: (scope, iElement, iAttrs) ->
    scope.next = ->
      index = _.findIndex(scope.images, (image) -> image.current == true)
      scope.images.forEach (image) -> image.current = false
      if index + 1 == scope.images.length
        scope.images[0].current = true
      else
        scope.images[index + 1].current = true

angular.module('voyageVoyage').directive 'vvTourImage', ->
  restrict: 'E'
  require: '^vvTourImageFlipper'
  template: "<img alt='' height='130' width='230' ng-click='onClick()' ng-src='{{ image.url }}' ng-show='image.current == true'>"
  scope:
    imageUrl: '@'
  link: (scope, iElement, iAttr, controller) ->
    # wrap the passed image url inside an object so as to keep state
    scope.image = {url: scope.imageUrl}
    controller.addImage(scope.image)

    scope.onClick = ->
      controller.next()
