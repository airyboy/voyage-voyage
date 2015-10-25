angular.module("voyageVoyage").factory "Entity", ->
  # класс используется для отмены редактирования объекта или для 
  # избежания ненужных запросов пользователю в случае если объект не был изменен или заполнен
  class Entity
    constructor: (@name) ->
    _copy = null
    keepCopy: ->
      _copy = Entity.fromJSON(this)
    @fromJSON: (json) ->
      entity = new Entity
      for key, val of json
        if typeof json[key] != 'function' && !(key.charAt(0) == '$')
          entity[key] = json[key]
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
