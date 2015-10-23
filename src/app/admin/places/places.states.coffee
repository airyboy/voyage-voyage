class PlaceBaseState
  constructor: ->
    @place = null
  newButShown: -> false
  newButDisabled: -> false
  newFormShown: -> false
  editRemoveShown: -> false
  editIndex: null

class BrowsePlaceState extends PlaceBaseState
  newButShown: -> true
  editRemoveShown: -> true

class NewPlaceState extends PlaceBaseState
  constructor: ->
    @place = new Place
  newFormShown: -> true

class EditPlaceState extends PlaceBaseState
  constructor: (@place, @editIndex) ->
    @place.keepCopy()
  newButDisabled: -> true
  newButShown: -> true
