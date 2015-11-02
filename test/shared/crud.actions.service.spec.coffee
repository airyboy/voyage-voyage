describe 'CRUD actions service', ->
  t = {}

  beforeEach -> module('voyageVoyage')

  beforeEach(inject ($controller, _PersistenceService_, _Entity_, _CRUDService_) ->
    t.crudService = _CRUDService_
    t.PersistenceService = _PersistenceService_
    t.Entity = _Entity_

    t.resource = 'some'
    t.collection = []
    t.obj = t.Entity.fromJSON { objectId: 1, name: 'name', text: 'text' }
    t.setState = ->

    spyOn(t.PersistenceService, 'saveResource')
    spyOn(t.collection, 'push').and.callThrough()
    spyOn(t, 'setState')
    spyOn(t.PersistenceService, 'removeResource')
  )

  describe 'add.', ->
    it 'Pushes the object in collection', ->
      t.crudService.add(t.resource, t.obj, t.collection, t.setState)
      expect(t.collection.push).toHaveBeenCalledWith(t.obj)
      expect(t.collection.length).toBe(1)
    it 'Calls saveResource', ->
      t.crudService.add(t.resource, t.obj, t.collection, t.setState)
      expect(t.PersistenceService.saveResource).toHaveBeenCalledWith(t.resource, t.obj)
    it 'Sets browse state', ->
      t.crudService.add(t.resource, t.obj, t.collection, t.setState)
      expect(t.setState).toHaveBeenCalledWith('browse')

  describe 'remove.', ->
    beforeEach -> t.collection.push(t.obj)

    it 'Removes the object from collection', ->
      spyOn(t.collection, 'splice').and.callThrough()
      t.crudService.remove(t.resource, 0, t.collection)
      expect(t.collection.splice).toHaveBeenCalled()
      expect(t.collection.length).toBe(0)
    it 'Calls removeResource', ->
      t.crudService.remove(t.resource, 0, t.collection)
      expect(t.PersistenceService.removeResource).toHaveBeenCalledWith(t.resource, t.obj)

  describe 'update.', ->
    beforeEach -> t.collection.push(t.obj)
    it 'Calls saveResource', ->
      t.obj.name = 'new name'
      t.crudService.update(t.resource, t.obj, t.setState)
      expect(t.PersistenceService.saveResource).toHaveBeenCalledWith(t.resource, t.obj)
    it 'Sets browse state', ->
      t.obj.name = 'new name'
      t.crudService.update(t.resource, t.obj, t.setState)
      expect(t.setState).toHaveBeenCalledWith('browse')
      expect(t.obj.name).toBe('new name')

  describe 'cancelEdit.', ->
    it 'calls rejectChanges on the object', ->
      spyOn(t.obj, 'rejectChanges')
      t.crudService.cancelEdit(t.obj, t.setState)
      expect(t.obj.rejectChanges).toHaveBeenCalled()
    it 'Sets browse state', ->
      t.crudService.cancelEdit(t.obj, t.setState)
      expect(t.setState).toHaveBeenCalledWith('browse')
