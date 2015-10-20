class BaseState
  constructor: ->
    @country = null
  newButShown: -> false
  newButDisabled: -> false
  newFormShown: -> false
  editRemoveShown: -> false
  editIndex: null

class BrowseState extends BaseState
  newButShown: -> true
  editRemoveShown: -> true

class NewState extends BaseState
  constructor: ->
    @country = new Country
  newFormShown: -> true

class EditState extends BaseState
  constructor: (@country, @editIndex) ->
    @country.keepCopy()
  newButDisabled: -> true
  newButShown: -> true
