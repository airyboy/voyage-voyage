class Tour
  constructor: (@title, @text, @countryId, @price) ->
    @id = moment().unix()
  _copy = null
  keepCopy: ->
    _copy = (new Tour).fromJSON(this)
  fromJSON: (json) ->
    { id: @id, title: @title, text: @text, countryId: @countryId, price: @price } = json
    this
  commitChanges: =>
    _copy = null
  rejectChanges: =>
    { id: @id, title: @title, text: @text, countryId: @countryId, price: @price } = _copy if _copy
    _copy = null
  hasChanges: =>
    !@isEqual(_copy)
  isEmpty: ->
    !@title & !@text & !@countryId & !@price
  isEqual: (other) ->
    this.text == other.text and this.title == other.title and this.countryId == other.countryId and this.price == other.price
