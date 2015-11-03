angular.module('voyageVoyage').service 'CRUDService', (PersistenceService, $log) ->
  {
    add: (resourceName, obj, collection, setStateCallback) ->
      PersistenceService.saveResource(resourceName, obj)
      collection.push obj
      setStateCallback 'browse'
    remove: (resourceName, idx, collection) ->
      obj = collection[idx]
      PersistenceService.removeResource(resourceName, obj)
      collection.splice(idx, 1)
    update: (resourceName, obj, setStateCallback) ->
      PersistenceService.saveResource(resourceName, obj)
      setStateCallback 'browse'
    cancelEdit: (obj, setStateCallback) ->
      obj.rejectChanges()
      setStateCallback 'browse'
}
