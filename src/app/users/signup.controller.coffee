angular.module('voyageVoyage') .controller 'SignUpController', ($scope, $routeParams, Parse, $state, toastr) ->
  $scope.signup = ->
    user = new Parse.User
    user.set('username', $scope.username)
    user.set('password', $scope.password)

    user.signUp null,
      success: (user) ->
        $state.go('home')
      error: (user, error) ->
        toastr.error('Please, choose another username. The one you given is already occupied.')

