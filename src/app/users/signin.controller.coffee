angular.module('voyageVoyage') .controller 'SignInController', ($scope, $routeParams, Parse) ->
  $scope.login = ->
    console.log 'start'
    Parse.User.logIn($scope.username, $scope.password,
    {
      success: (user) -> console.log "Logged in"
      error: (user, error) -> console.log error
    })
