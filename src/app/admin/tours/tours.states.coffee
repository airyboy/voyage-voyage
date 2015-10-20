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
    if @tour.isEmpty() or confirm("Есть несохраненные изменения. Продолжить?")
      true
    else
      false

class InlineEditState extends BaseState
  constructor: (@tour, @editIndex) ->
    @tour.keepCopy()
  listShown: -> true
  canCancel: ->
    if !@tour.hasChanges() or confirm("Есть несохраненные изменения. Продолжить?")
      true
    else
      false

class BrowseState extends BaseState
  listShown: -> true
  newButShown: -> true

class UserBrowseState extends BaseState
  listShown: -> true
