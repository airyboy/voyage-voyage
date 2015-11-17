angular.module('voyageVoyage').service 'PersistenceService', ['$resource', '$q', 'ResourceFactory', '$log',
($resource, $q, ResourceFactory, $log) ->
  {
    loadResourceById: (resourceName, objectId) ->
      ResourceFactory(resourceName).getById { objectId: objectId }

    loadResource: (resourceName) ->
      ResourceFactory(resourceName).query()

    saveResource: (resourceName, obj) ->
      res = ResourceFactory(resourceName)
      db = new res(obj)
      
      if !obj.objectId
        db.$save()
          .then (response) ->
            obj.objectId = response.objectId
            response
          .catch (error) ->
            $log.error error
            alert "Error!"
      else
        db.$update()
          .then (response) ->
            obj.commitChanges()
            response
          .catch (error) ->
            $log.error error
            alert "Error!"
            
    removeResource: (resourceName, obj) ->
      res = ResourceFactory(resourceName)
      db = new res({ objectId: obj.objectId })
      db.$remove()
        .catch (error) ->
          $log.error error
          alert "Error!"
  }
]
