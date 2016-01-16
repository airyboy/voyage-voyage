angular.module('voyageVoyage') .controller 'SignUpController', ($scope, $routeParams, Parse) ->
  $scope.signup = ->
    user = new Parse.User
    user.set('username', $scope.username)
    user.set('password', $scope.password)

    user.signUp null,
      success: (user) ->
        console.log "Ok"
      error: (user, error) ->
        console.log error

