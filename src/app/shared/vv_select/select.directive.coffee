angular.module('voyageVoyage').directive 'vvSelect', ['_', (_) ->
  restrict: 'E'
  templateUrl: 'app/shared/vv_select/select.html'
  require: '?ngModel'
  scope:
    model: '=ngModel'
    items: '='
    displayField: '@'
    valueField: '@'
    emptyText: '@'
  link: (scope, iElement, iAttr, modelController) ->
    scope.current = scope.emptyText || 'Choose'

    el = angular.element(iElement[0].firstChild)
    el.on 'click', ->
      el.toggleClass('active')

    scope.$watch 'model', (newValue) ->
      found = _.find(scope.items, (item) -> item[scope.valueField] == newValue)
      scope.current = found[scope.displayField] if found

    scope.reset = ->
      modelController.$setViewValue('')
      scope.current = scope.emptyText

    scope.change = (item) ->
      scope.$evalAsync ->
        modelController.$setViewValue(item[scope.valueField])
        console.log item
        scope.current = item[scope.displayField]
]
