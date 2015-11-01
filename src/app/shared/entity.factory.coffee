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
      angular.extend(entity, json)
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
      _.chain(_.keys(this))
      .filter(((key) -> typeof this[key] != 'function'), this) # удаляем ключи с функциями
      .reduce(((result, key) -> result & !this[key]), true, this) # сворачиваем
      .value()
    isEqual: (other) ->
      _.chain(_.keys(this))
      .filter(((key) -> typeof this[key] != 'function'), this) # удаляем ключи с функциями
      .reduce(((result, key) -> result & (this[key] == other[key])), true, this) # сворачиваем
      .value()
    @fromArray: (jsonArray) ->
      result = (Entity.fromJSON(e) for e in jsonArray)
