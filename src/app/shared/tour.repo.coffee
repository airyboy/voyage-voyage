angular.module('voyageVoyage').service 'TTourRepository',
($http, $log, $q, Entity, _) ->
  self = {}

  self.tours = {}
  self.baseUrl = 'https://api.parse.com/1/classes/'

  self.count = ->
    promise = $http.get(self.baseUrl + 'tour' + '?count=1&limit=0')

  self.all = (refresh) ->
    if Object.keys(self.all).length == 0 || refresh
      promise = $http.get(self.baseUrl + 'tour')
        .then (response) ->
          response.data.results.forEach (tour) ->
            self.tours[tour.objectId] = Entity.fromJSON(tour)
          self.tours
        .catch (error) -> $log.error(error)
      self.tours['$promise'] = promise
    else
      deferred = $q.defer()
      deferred.resolve(self.tours)
      self.tours['$promise'] = deferred.promise
    self.tours

  self.getById = (id, refresh) ->
    if !self.tours.hasOwnProperty(id) || refresh
      #from server
      self.tours[id] = {}
      promise = $http.get(self.baseUrl + "tour/#{id}")
        .then (response) ->
          angular.extend(self.tours[id], Entity.fromJSON(response.data))
          self.tours[id]
        .catch (error) -> $log.error(error)
      self.tours[id]['$promise'] = promise
    else
      #cache hit
      deferred = $q.defer()
      deferred.resolve(self.tours[id])
      self.tours[id]['$promise'] = deferred.promise
    self.tours[id]

  self.save = (tour) ->
    promise = null
    if !tour.objectId
      # inserting the new object at the temporary key
      uniqueId = _.uniqueId()
      self.tours[uniqueId] = tour
      promise = $http.post(self.baseUrl + 'tour', tour)
        .then (response) ->
          tour.objectId = response.objectId
          self.tours[tour.objectId] = tour
          # removing the temporary object
          delete self.tours[uniqueId]
          self.tours[tour.objectId]
        .catch (error) -> $log.error(error)
    else
      self.tours[tour.objectId] = tour
      promise = $http.put(self.baseUrl + "tour/#{tour.objectId}", tour)
    promise

  self.remove = (tour) ->
    promise = $http.delete(self.baseUrl + "tour/#{tour.objectId}")
      .then (response) ->
        delete self.tours[tour.objectId] if self.tours[tour.objectId]
      .catch (error) -> $log.error(error)
    promise

  self
