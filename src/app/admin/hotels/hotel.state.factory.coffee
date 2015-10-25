angular.module("voyageVoyage").factory "HotelStateFactory", (Entity) ->
  class HotelBaseState
    constructor: ->
      @hotel = null
    newButShown: -> false
    newButDisabled: -> false
    newFormShown: -> false
    editRemoveShown: -> false
    editIndex: null

  class BrowseHotelState extends HotelBaseState
    newButShown: -> true
    editRemoveShown: -> true

  class NewHotelState extends HotelBaseState
    constructor: ->
      @hotel = new Entity
    newFormShown: -> true

  class EditHotelState extends HotelBaseState
    constructor: (@hotel, @editIndex) ->
      @hotel.keepCopy()
    newButDisabled: -> true
    newButShown: -> true

  (state, hotel, idx) ->
    console.log state
    theState = switch state
      when 'browse' then new BrowseHotelState
      when 'add' then new NewHotelState
      when 'edit' then new EditHotelState(hotel, idx)

    theState
