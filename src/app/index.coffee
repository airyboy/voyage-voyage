app = angular.module "voyageVoyage", []

#TODO: константы пока здесь
UNSAVED_CHANGES_WARNING = "Есть несохраненные изменения. Продолжить?"
REMOVE_WARNING = "Удалить тур?"

app.controller "ToursController", ($scope) ->
  $scope.persistence = {
    save: () ->
      localStorage.setItem("tours", angular.toJson($scope.tours))
    load: () ->
      json = localStorage.getItem("tours")
      $scope.tours = ((new Tour).fromJSON(e) for e in angular.fromJson(json))
  }

  if localStorage.getItem("tours") != null
    $scope.persistence.load()
  else
    $scope.tours = tours_default

  $scope.new = {
    tour: new Tour
    isNew: false
    setNew: () ->
      this.isNew = true
    add: () ->
      $scope.tours.push(angular.copy(this.tour))
      $scope.persistence.save()
      this.reset()
    reset: () ->
      this.tour = new Tour()
      this.isNew = false
    cancel: () ->
      # если форма пустая просто закрываем
      if this.tour.isEmpty()
        this.reset()
      else
        # если пользователь что-то ввел, спрашиваем
        if confirm(UNSAVED_CHANGES_WARNING)
          this.reset()
  }

  $scope.edit = {
    index: null
    # сохраняем сюда копию тура, которую и редактируем
    tour: null
    isEdit: (idx) ->
      this.index != null && this.index == idx
    setTour: (idx, tour) ->
      $scope.edit.index = idx
      $scope.edit.tour = angular.copy(tour)
    update: () ->
      $scope.tours[this.index] = this.tour
      $scope.persistence.save()
      this.reset()
    cancel: () ->
      if this.tour.areEqual($scope.tours[this.index])
        this.reset()
      else
        if confirm(UNSAVED_CHANGES_WARNING)
          this.reset()
    reset: () ->
      this.tour = null
      this.index = null
  }
  
  $scope.remove = (idx) ->
    if confirm(REMOVE_WARNING)
      $scope.tours.splice(idx, 1)
      $scope.persistence.save()

class Tour
  constructor: (@title, @text, @country, @price) ->
  isEmpty: ->
    !@title & !@text & !@country & !@price
  areEqual: (otherTour) ->
    this.text == otherTour.text and this.title == otherTour.title and this.country == otherTour.country and this.price == otherTour.price
  fromJSON: (json) ->
    @title = json.title
    @text = json.text
    @country = json.country
    @price = json.price
    this

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
