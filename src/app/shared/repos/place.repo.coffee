angular.module('voyageVoyage').service 'PlaceRepository', 
($http, $log, $q, Entity, _) ->
  self = {}

  self.places = []
  self.baseUrl = 'https://api.parse.com/1/classes/'

  self.count = ->
    promise = $http.get(self.baseUrl + 'place' + '?count=1&limit=0')

  self.all = (refresh) ->
    if self.places.length == 0 || refresh
      promise = $http.get(self.baseUrl + 'place')
        .then (response) ->
          #clear array
          while (self.places.length > 0)
            self.places.pop()
          response.data.results.forEach (place) ->
            self.places.push(Entity.fromJSON(place))
          self.places
        .catch (error) -> $log.error(error)
      self.places['$promise'] = promise
    else
      deferred = $q.defer()
      deferred.resolve(self.places)
      self.places['$promise'] = deferred.promise
    self.places

  self.getById = (id, refresh) ->
    index = null
    # from server
    if self.places.length == 0 || !_.find(self.places, (place) -> place.objectId == id) || refresh
      index = _.findIndex(self.places, (place) -> place.objectId == id) if refresh # look up index for refreshing
      # if the id wasn't found in cache, we insert the empty object and keep the last index
      index = self.places.push({}) - 1 if index == -1 || index == null
      promise = $http.get(self.baseUrl + 'place/' + id)
        .then (response) ->
          angular.extend(self.places[index], Entity.fromJSON(response.data))
          self.places[index]
        .catch (error) -> $log.error(error)
      self.places[index]['$promise'] = promise
    # cache hit
    else
      deferred = $q.defer()
      index = _.findIndex(self.places, (place) -> place.objectId == id)
      deferred.resolve(self.places[index])
      self.places[index]['$promise'] = deferred.promise
    self.places[index]

  self.save = (place) ->
    promise = null
    if !place.objectId  # the object is a new one
      promise = $http.post(self.baseUrl + 'place', place)
        .then (response) ->
          place.objectId = response.data.objectId
          self.places.push(place)
        .catch (error) -> $log.error(error)
    else # updating the object
      promise = $http.put(self.baseUrl + 'place/' + place.objectId, place)
    promise

  self.remove = (place) ->
    index = _.findIndex(self.places, (t) -> place.objectId == t.objectId)
    $http.delete(self.baseUrl + 'place/' + place.objectId).then (response) ->
      self.places.splice(index, 1)

  self

