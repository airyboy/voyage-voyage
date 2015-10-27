angular.module("voyageVoyage").factory "SimpleStateFactory", (Entity) ->
  # здесь используем name в конструкторе, чтобы удобно обращаться из представления к текущему
  # редактируемому объекту: state.hotel, state.place...
  class BaseState
    constructor: (name) ->
      this[name] = null
    newButShown: -> false
    newButDisabled: -> false
    newFormShown: -> false
    editRemoveShown: -> false
    editIndex: null

  class BrowseState extends BaseState
    newButShown: -> true
    editRemoveShown: -> true

  class NewState extends BaseState
    constructor: (name) ->
      this[name] = new Entity
    newFormShown: -> true

  class EditState extends BaseState
    constructor: (name, entity, @editIndex) ->
      this[name] = entity
      this[name].keepCopy()
    newButDisabled: -> true
    newButShown: -> true

  #name - имя сущности
  #state - имя состояния
  #entity - редактируемый объект
  #idx - индекс объекта  в массиве
  (name, state, entity, idx) ->
    theState = switch state
      when 'browse' then new BrowseState(name)
      when 'add' then new NewState(name)
      when 'edit' then new EditState(name, entity, idx)

    theState
