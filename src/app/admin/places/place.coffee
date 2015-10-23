class Place
  constructor: (@name) ->
    @id = moment().unix()
  _copy = null
  keepCopy: ->
    _copy = (new Place).fromJSON(this)
  fromJSON: (json) ->
    { objectId: @objectId, id: @id, name: @name, country: @country } = json
    this
  commitChanges: ->
    _copy = null
  rejectChanges: ->
    { id: @id, name: @name, country: @country } = _copy if _copy
    _copy = null
  hasChanges: =>
    !@isEqual(_copy)
  isEmpty: ->
    !@name
  isEqual: (other) ->
    this.name == other.name

