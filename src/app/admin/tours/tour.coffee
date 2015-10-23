class Tour
  constructor: (@title, @text, @countryId, @duration, @placeId, @price) ->
    @id = moment().unix()
  _copy = null
  keepCopy: ->
    _copy = (new Tour).fromJSON(this)
  @fromJson: (json) ->
    t = new Tour()
    angular.extend(t, json)
    t
  fromJSON: (json) ->
    {
      objectId: @objectId,
      id: @id,
      title: @title,
      text: @text,
      countryId: @countryId,
      duration: @duration,
      placeId: @placeId,
      price: @price } = json
    this
  commitChanges: ->
    _copy = null
  rejectChanges: =>
    { objectId: @objectId, id: @id, title: @title, text: @text, countryId: @countryId, duration: @duration, price: @price } = _copy if _copy
    _copy = null
  hasChanges: =>
    !@isEqual(_copy)
  isEmpty: ->
    !@title & !@text & !@countryId & !@price & !@duration
  isEqual: (other) ->
    this.text == other.text and this.title == other.title and this.countryId == other.countryId and this.price == other.price
