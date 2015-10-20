angular.module "voyageVoyage"
  .config ($routeProvider, $locationProvider) ->
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
      .otherwise {
        redirectTo: '/'
      }

    $locationProvider.html5Mode true
