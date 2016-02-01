angular.module "voyageVoyage"
  .config ($urlRouterProvider, $locationProvider, $httpProvider, $stateProvider) ->
    $stateProvider
      .state 'home',
        url: '/'
        views:
          'nav':
            templateUrl: 'app/shared/nav.html'
            controller: 'SignInController'
          'main':
            templateUrl: 'app/tours/index.html'
            controller: 'ToursController'
      .state 'login',
        url: '/login'
        views:
          'nav':
            templateUrl: 'app/shared/nav.html'
            controller: 'SignInController'
          'main':
            templateUrl: 'app/users/login.html'
            controller: 'SignInController'
      .state 'signup',
        url: '/signup'
        views:
          'nav':
            templateUrl: 'app/shared/nav.html'
            controller: 'SignInController'
          'main':
            templateUrl: 'app/users/signup.html'
            controller: 'SignUpController'
      .state 'tour',
        url: '/tour/:id'
        views:
          'nav':
            templateUrl: 'app/shared/nav.html'
            controller: 'SignInController'
          'main':
            templateUrl:  'app/tours/show.html'
            controller: 'TourController'
      .state 'admin',
        url: '/admin'
        views:
          'nav':
            templateUrl: 'app/shared/nav.html'
            controller: 'SignInController'
          'main':
            templateUrl:  'app/admin/tours/index.html'
            controller: 'AdminToursController'
      .state 'places',
        views:
          'nav':
            templateUrl: 'app/shared/nav.html'
            controller: 'SignInController'
          'main':
            templateUrl:  'app/admin/places/index.html'
            controller: 'PlacesController'
      .state 'countries',
        views:
          'nav':
            templateUrl: 'app/shared/nav.html'
            controller: 'SignInController'
          'main':
            templateUrl:  'app/admin/countries/index.html'
            controller: 'CountriesController'
      .state 'hotels',
        views:
          'nav':
            templateUrl: 'app/shared/nav.html'
            controller: 'SignInController'
          'main':
            templateUrl:  'app/admin/hotels/index.html'
            controller: 'HotelsController'

    $urlRouterProvider.otherwise('/')

    $locationProvider.html5Mode true

    $httpProvider.defaults.headers.common = {
      'X-Parse-Application-Id':'sXYBJKAzNLajxXs0SqkpjDmPKSY8eES5c4xOH275'
      'X-Parse-REST-API-Key': 'kqikw9hrrEcVjXzXYBl3CpWstA9RodV2tOoKqFa0'
    }
