app = angular.module "voyageVoyage", []

class Tour
  constructor: (@title, @text, @country, @price) ->
  _copy = null
  keepCopy: ->
    _copy = (new Tour).fromJSON(this)
  fromJSON: (json) ->
    { title: @title, text: @text, country: @country, price: @price } = json
    this
  commitChanges: =>
    _copy = null
  rejectChanges: =>
    if _copy
      { title: @title, text: @text, country: @country, price: @price } = _copy
      _copy = null
  hasChanges: =>
    !@isEqual(_copy)
  isEmpty: ->
    !@title & !@text & !@country & !@price
  isEqual: (otherTour) ->
    this.text == otherTour.text and this.title == otherTour.title and this.country == otherTour.country and this.price == otherTour.price

lorem = "Lorem ipsum dolor sit amet. Magnam aliquam quaerat voluptatem sequi." +
    " Corporis suscipit laboriosam, nisi ut enim ipsam voluptatem quia. Velit esse, " +
    "quam nihil impedit, quo voluptas nulla. Sint, obcaecati cupiditate non recusandae " +
    "ipsam voluptatem, quia voluptas nulla vero. Officia deserunt mollitia animi, id est " +
    "laborum et harum. Aperiam eaque ipsa, quae ab illo inventore veritatis et dolore magnam " +
    "aliquam. Voluptas sit, amet, consectetur adipisci. Deleniti atque corrupti, quos dolores " +
    "eos, qui dolorem ipsum."
    
json = [
  { title: 'Мытищи', country: 'Россия', text: lorem, price: 5000.0 },
  { title: 'Реутов', country: 'Россия', text: lorem, price: 40000.0 },
  { title: 'Одинцово', country: 'Россия', text: lorem, price: 8000.0 },
  { title: 'Щербинка', country: 'Россия', text: lorem, price: 90500.0 }
]

tours_default = ((new Tour).fromJSON(e) for e in json)

class BaseState
  constructor: ->
    @tour = null
  newFormShown: -> false
  listShown: -> false
  newButShown: -> false
  tour: null
  editIndex: null
  canCancel: -> true

class NewState extends BaseState
  constructor: ->
    @tour = new Tour
  newFormShown: -> true
  canCancel: =>
    answer = false
    # если форма пустая просто закрываем
    if @tour.isEmpty()
      answer = true
    else
      # если пользователь что-то ввел, спрашиваем
      if confirm(UNSAVED_CHANGES_WARNING)
        answer = true
    answer

class InlineEditState extends BaseState
  constructor: (@tour, @editIndex) ->
    @tour.keepCopy()
  listShown: -> true
  canCancel: ->
    console.log @tour
    answer = false
    console.log @tour.hasChanges()
    if !@tour.hasChanges()
      answer = true
    else
      if confirm(UNSAVED_CHANGES_WARNING)
        answer = true
    answer

class BrowseState extends BaseState
  listShown: -> true
  newButShown: -> true

#TODO: константы пока здесь
UNSAVED_CHANGES_WARNING = "Есть несохраненные изменения. Продолжить?"
REMOVE_WARNING = "Удалить тур?"

app.controller "ToursController", ($scope) ->
  $scope.title = "Title"
  $scope.uiState = new BrowseState
  $scope.tour = null

  $scope.setState = (state, tour, idx) ->
    console.log state
    $scope.uiState = switch state
      when 'browse' then new BrowseState
      when 'new' then new NewState
      when 'inlineEdit' then new InlineEditState(tour, idx)
    $scope.tour = $scope.uiState.tour
    console.log $scope.uiState

  $scope.persistence = {
    save: ->
      localStorage.setItem("tours", angular.toJson($scope.tours))
    load: ->
      json = localStorage.getItem("tours")
      $scope.tours = ((new Tour).fromJSON(e) for e in angular.fromJson(json))
  }

  if localStorage.getItem("tours") != null
    $scope.persistence.load()
  else
    $scope.tours = tours_default

  $scope.add = ->
    $scope.tours.push(angular.copy(this.tour))
    $scope.persistence.save()
    $scope.setState("browse")
    
  $scope.update = ->
    $scope.tour.commitChanges()
    $scope.persistence.save()
    $scope.setState("browse")

  $scope.cancel = ->
    if $scope.uiState.canCancel()
      $scope.tour.rejectChanges()
      $scope.setState("browse")

  $scope.remove = (idx) ->
    if confirm(REMOVE_WARNING)
      $scope.tours.splice(idx, 1)
      $scope.persistence.save()
