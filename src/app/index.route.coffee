angular.module "voyageVoyage"
  .config ($routeProvider) ->
    $routeProvider
      .when '/admin', {
        templateUrl: 'app/admin/tours/index.html'
        controller: 'AdminToursController'
      }
      .when '/admin/countries', {
        templateUrl: 'app/admin/countries/index.html'
        controller: 'CountriesController'
      }
      .when '/', {
        templateUrl: 'app/tours/index.html'
        controller: 'ToursController'
      }
      .when '/tour/:slug', {
        templateUrl: 'app/tours/show.html'
        controller: 'TourController'
      }
