angular.module('voyageVoyage') .controller 'SignInController', ($scope, $routeParams, $location, $window, Parse, $state) ->
  $scope.name = 'some name'

  $scope.login = ->
    console.log 'start'
    Parse.User.logIn($scope.username, $scope.password,
    {
      success: (user) ->
        console.log "Logged in"
        $window.location = ('/')
        $scope.apply()
      error: (user, error) -> console.log error
    })

  $scope.current = ->
    Parse.User.current()

  $scope.userName = ->
    Parse.User.current().getUsername()

  $scope.logOut = ->
    Parse.User.logOut()
    $state.go('home')
    $scope.apply()
