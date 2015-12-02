angular.module('voyageVoyage').directive 'vvTourImage', ->
  restrict: 'E'
  require: '^vvTourImageFlipper'
  templateUrl: 'app/shared/tour_images/tour.image.html'
  scope:
    imageUrl: '@'
  link: (scope, iElement, iAttr, controller) ->
    # wrap the passed image url inside an object so as to keep state
    scope.image = {url: scope.imageUrl}
    controller.addImage(scope.image)

    scope.onClick = ->
      controller.next()
