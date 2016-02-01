angular.module("voyageVoyage").run (NewTourNotification, $rootScope, $location, Parse) ->
  NewTourNotification.init()

  $rootScope.$on '$locationChangeStart', (event, newUrl, oldUrl) ->
    if /admin/.test(newUrl) & !Parse.User.current()
      event.preventDefault()
      $location.path('/login')

    console.log newUrl
    console.log oldUrl
