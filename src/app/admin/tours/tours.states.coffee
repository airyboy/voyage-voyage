angular.module("voyageVoyage").factory "TourStateFactory", (Entity) ->
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
      @tour = new Entity
    newFormShown: -> true
    canCancel: =>
      @tour.isEmpty()

  class InlineEditState extends BaseState
    constructor: (@tour, @editIndex) ->
      @tour.keepCopy()
    listShown: -> true
    canCancel: ->
      !@tour.hasChanges()

  class BrowseState extends BaseState
    listShown: -> true
    newButShown: -> true

  class UserBrowseState extends BaseState
    listShown: -> true

  (state, tour, idx) ->
    theState = switch state
      when 'browse' then new BrowseState
      when 'new' then new NewState
      when 'inlineEdit' then new InlineEditState(tour, idx)

    theState
