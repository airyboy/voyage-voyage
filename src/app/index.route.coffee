angular.module "voyageVoyage"
  .config ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when '/', {
        templateUrl: 'app/tours/index.html'
        controller: 'ToursController'
      }
      .when '/tour/:slug', {
        templateUrl: 'app/tours/show.html'
        controller: 'TourController'
      }
      .when '/admin', {
        templateUrl: 'app/admin/tours/index.html'
        controller: 'AdminToursController'
      }
      .when '/admin/countries', {
        templateUrl: 'app/admin/countries/index.html'
        controller: 'CountriesController'
      }
      .when '/admin/places', {
        templateUrl: 'app/admin/places/index.html'
        controller: 'PlacesController'
      }
      .when '/admin/hotels', {
        templateUrl: 'app/admin/hotels/index.html'
        controller: 'HotelsController'
      }
      .otherwise {
        redirectTo: '/'
      }

    $locationProvider.html5Mode true

    $httpProvider.defaults.headers.common = {
      'X-Parse-Application-Id':'sXYBJKAzNLajxXs0SqkpjDmPKSY8eES5c4xOH275'
      'X-Parse-REST-API-Key': 'kqikw9hrrEcVjXzXYBl3CpWstA9RodV2tOoKqFa0'
    }
