class Country
  constructor: (@name) ->
    @id = moment().unix()
  _copy = null
  keepCopy: ->
    _copy = (new Country).fromJSON(this)
  fromJSON: (json) ->
    { id: @id, name: @name } = json
    this
  commitChanges: =>
    _copy = null
  rejectChanges: =>
    if _copy
      { id: @id, name: @name } = _copy
      _copy = null
  hasChanges: =>
    !@isEqual(_copy)
  isEmpty: ->
    !@name
  isEqual: (other) ->
    this.name == other.name

