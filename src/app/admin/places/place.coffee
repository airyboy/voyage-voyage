class Place
  constructor: (@name) ->
  _copy = null
  keepCopy: ->
    _copy = (new Place).fromJSON(this)
  fromJSON: (json) ->
    { objectId: @objectId, name: @name, countryId: @countryId } = json
    this
  commitChanges: ->
    _copy = null
  rejectChanges: ->
    { name: @name, countryId: @countryId } = _copy if _copy
    _copy = null
  hasChanges: =>
    !@isEqual(_copy)
  isEmpty: ->
    !@name
  isEqual: (other) ->
    this.name == other.name

