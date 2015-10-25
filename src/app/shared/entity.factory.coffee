angular.module("voyageVoyage").factory "Entity", ->
  class Entity
    constructor: (@name) ->
    _copy = null
    keepCopy: ->
      _copy = Entity.fromJSON(this)
    @fromJSON: (json) ->
      entity = new Entity
      angular.extend(entity, json)
      entity
    commitChanges: ->
      _copy = null
    rejectChanges: ->
      for key, val of _copy
        if typeof _copy[key] != 'function'
          this[key] = _copy[key]
      _copy = null
    hasChanges: =>
      !@isEqual(_copy)
    isEmpty: ->
      result = true
      for key, val of this
        if typeof this[key] != 'function'
          result = result & !this[key]
      result
    isEqual: (other) ->
      result = true
      for key, val of this
        if typeof this[key] != 'function'
          result = result & (this[key] == other[key])
      result
    @fromArray: (jsonArray) ->
      result = (Entity.fromJSON(e) for e in jsonArray)

