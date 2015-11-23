angular.module('voyageVoyage').service 'PlaceRepository',
($http, $log, $q, Entity, _) ->
  self = {}

  self.places = {}
  self.baseUrl = 'https://api.parse.com/1/classes/'

  self.count = ->
    promise = $http.get(self.baseUrl + 'place' + '?count=1&limit=0')

  self.all = (refresh) ->
    if Object.keys(self.all).length == 0 || refresh
      promise = $http.get(self.baseUrl + 'place')
        .then (response) ->
          response.data.results.forEach (place) ->
            self.places[place.objectId] = Entity.fromJSON(place)
          self.places
        .catch (error) -> $log.error(error)
      self.places['$promise'] = promise
    else
      deferred = $q.defer()
      deferred.resolve(self.places)
      self.places['$promise'] = deferred.promise
    self.places

  self.getById = (id, refresh) ->
    if !self.places.hasOwnProperty(id) || refresh
      #from server
      self.places[id] = {}
      promise = $http.get(self.baseUrl + "place/#{id}")
        .then (response) ->
          angular.extend(self.places[id], Entity.fromJSON(response.data))
          self.places[id]
        .catch (error) -> $log.error(error)
      self.places[id]['$promise'] = promise
    else
      #cache hit
      deferred = $q.defer()
      deferred.resolve(self.places[id])
      self.places[id]['$promise'] = deferred.promise
    self.places[id]

  self.save = (place) ->
    promise = null
    if !place.objectId
      # inserting the new object at the temporary key
      uniqueId = _.uniqueId()
      self.places[uniqueId] = place
      promise = $http.post(self.baseUrl + 'place', place)
        .then (response) ->
          place.objectId = response.objectId
          self.places[place.objectId] = place
          # removing the temporary object
          delete self.places[uniqueId]
          self.places[place.objectId]
        .catch (error) -> $log.error(error)
    else
      self.places[place.objectId] = place
      promise = $http.put(self.baseUrl + "place/#{place.objectId}", place)
    promise

  self.remove = (place) ->
    promise = $http.delete(self.baseUrl + "place/#{place.objectId}")
      .then (response) ->
        delete self.places[place.objectId] if self.places[place.objectId]
      .catch (error) -> $log.error(error)
    promise

  self
