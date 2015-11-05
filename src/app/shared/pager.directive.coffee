angular.module('voyageVoyage').directive 'vvPager', ->
  restrict: 'E'
  templateUrl: 'app/shared/pager.html'
  scope:
    currentPage: '@'
    totalPages: '='
    pageChangedCallback: '&pageChanged'
  link: (scope, iElement, iAttr) ->
    scope.pages = [1..scope.totalPages]

    scope.setPage = (page) ->
      pageChanged(page)
