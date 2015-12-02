angular.module('voyageVoyage').directive 'vvTourImageFlipper', ->
  restrict: 'E'
  templateUrl: 'app/shared/tour_images/tour.image.flipper.html'
  transclude: true
  scope: {}
  controller: ['$scope', '_', ($scope, _) ->
    $scope.images = []
    @addImage = (image) ->
      image['current'] = true if $scope.images.length == 0
      $scope.images.push(image)
      console.log image
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
    

