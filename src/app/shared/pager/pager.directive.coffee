angular.module('voyageVoyage').directive 'vvPager', ->
  restrict: 'E'
  templateUrl: 'app/shared/pager/pager.html'
  scope:
    currentPage: '='
    pageSize: '@'
    totalItems: '@'
    pageChangedCallback: '&pageChanged'
  link: (scope, iElement, iAttr) ->
    scope.$watch 'totalItems', ->
      scope.totalPages = Math.ceil(scope.totalItems/scope.pageSize)
      scope.pages = [1..scope.totalPages]

    scope.setPage = (page) ->
      scope.currentPage = page
      scope.pageChangedCallback({ page: page })

    scope.pageForward = ->
      ++scope.currentPage if scope.currentPage != scope.pages.length
      scope.pageChangedCallback({ page: scope.currentPage })

    scope.pageBackward = ->
      --scope.currentPage if scope.currentPage != 1
      scope.pageChangedCallback({ page: scope.currentPage })
