app = angular.module "voyageVoyage", []

#TODO: константы пока здесь
UNSAVED_CHANGES_WARNING = "Есть несохраненные изменения. Продолжить?"
REMOVE_WARNING = "Удалить тур?"

app.controller "ToursController", ($scope) ->
  $scope.tours = tours

  $scope.new = {
    #TODO: вынести в модель, когда настанет время
    emptyTour: { title: null, country: null, text: null, price: 0.0 }
    tour: null
    isNew: false
    setNew: () ->
      this.isNew = true
    add: () ->
      $scope.tours.push(angular.copy(this.tour))
      this.reset()
    reset: () ->
      this.tour = angular.copy(this.emptyTour)
      this.isNew = false
    cancel: () ->
      # если форма пустая просто закрываем
      if this.isEmpty(this.tour)
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
      this.reset()
    cancel: () ->
      if areEqual(tour, $scope.tours[this.index])
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

  #TODO: это надо бы вынести в модель
  this.isEmpty = (tour) ->
    tour.text == null and tour.title == null and tour.country == null and tour.price == 0.0

  this.areEqual = (tour1, tour2) ->
    tour1.text == tour2.text and tour1.title == tour2.title and tour1.country == tour2.country and tour1.price == tour2.price

lorem = "Lorem ipsum dolor sit amet. Magnam aliquam quaerat voluptatem sequi." +
    " Corporis suscipit laboriosam, nisi ut enim ipsam voluptatem quia. Velit esse, " +
    "quam nihil impedit, quo voluptas nulla. Sint, obcaecati cupiditate non recusandae " +
    "ipsam voluptatem, quia voluptas nulla vero. Officia deserunt mollitia animi, id est " +
    "laborum et harum. Aperiam eaque ipsa, quae ab illo inventore veritatis et dolore magnam " +
    "aliquam. Voluptas sit, amet, consectetur adipisci. Deleniti atque corrupti, quos dolores " +
    "eos, qui dolorem ipsum."
    
tours = [
  {
    title: 'Мытищи',
    country: 'Россия',
    text: lorem,
    price: 5000.0
  },
  {
    title: 'Реутов',
    country: 'Россия',
    text: lorem,
    price: 40000.0
  },
  {
    title: 'Одинцово',
    country: 'Россия',
    text: lorem,
    price: 8000.0
  },
  {
    title: 'Щербинка',
    country: 'Россия',
    text: lorem,
    price: 90500.0
  }
]
