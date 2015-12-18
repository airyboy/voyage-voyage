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

    # the directive works in two following modes:
    # 1. if a value-field attribute is set, it binds ng-model to this field
    # 2. otherwise the ng-model value is the chosen object itself
    valueFieldSet = !!scope.valueField

    if !valueFieldSet
      modelController.$parsers.push (index) ->
        scope.items[index]

    el = angular.element(iElement[0].firstChild)
    el.on 'click', ->
      el.toggleClass('active')

    scope.$watch 'model', (newValue) ->
      if newValue
        updateViewValue(newValue)
      else
        scope.current = scope.emptyText || 'Choose'

    updateViewValue = (val) ->
      if valueFieldSet
        found = _.find(scope.items, (item) -> item[scope.valueField] == val)
        scope.current = found[scope.displayField] if found
      else
        scope.current = val[scope.displayField]

    scope.reset = ->
      modelController.$setViewValue(null)
      scope.current = scope.emptyText

    scope.change = (item, index) ->
      scope.$evalAsync ->
        viewVal = if valueFieldSet then item[scope.valueField] else index
        modelController.$setViewValue(viewVal)
        scope.current = item[scope.displayField]
]
