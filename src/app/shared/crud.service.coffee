angular.module('voyageVoyage').service 'CRUDService', (PersistenceService, $log) ->
  {
    add: (resourceName, obj, collection, setState) ->
      PersistenceService.saveResource(resourceName, obj)
      collection.push obj
      setState 'browse'
    remove: (resourceName, idx, collection) ->
      obj = collection[idx]
      PersistenceService.removeResource(resourceName, obj)
      collection.splice(idx, 1)
    update: (resourceName, obj, setState) ->
      PersistenceService.saveResource(resourceName, obj)
      setState 'browse'
    cancelEdit: (obj, setState) ->
      obj.rejectChanges()
      setState 'browse'
}
