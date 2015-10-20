angular.module('voyageVoyage') .controller 'TourController', ($scope, $routeParams,  PersistenceService, _) ->
  do ->
    json = PersistenceService.load()
    found  = _.find json, (tour) ->
      tour.id == +$routeParams.slug
    if found
      $scope.tour = found
