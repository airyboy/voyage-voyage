class Country
  constructor: (@name) ->
  _copy = null
  keepCopy: ->
    _copy = (new Country).fromJSON(this)
  fromJSON: (json) ->
    { objectId: @objectId, name: @name } = json
    this
  commitChanges: ->
    _copy = null
  rejectChanges: ->
    { name: @name } = _copy if _copy
    _copy = null
  hasChanges: =>
    !@isEqual(_copy)
  isEmpty: ->
    !@name
  isEqual: (other) ->
    this.name == other.name
