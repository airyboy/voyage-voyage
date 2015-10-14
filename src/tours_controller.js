var app = angular.module("voyageVoyage", []);

app.controller('ToursController', function($scope) {
  $scope.tours = tours;
  $scope.title = "Voyage";
});

var tours = [
  {title: 'Мытищи', country: 'Россия', text: '', price: 50.0},
  {title: 'Реутов', country: 'Россия', text: '', price: 40.0},
  {title: 'Одинцово', country: 'Россия', text: '', price: 80.0},
  {title: 'Щербинка', country: 'Россия', text: '', price: 90.0}
];
