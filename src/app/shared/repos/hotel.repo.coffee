angular.module('voyageVoyage').service 'HotelRepository', 
($http, $log, $q, Entity, _) ->
  self = {}

  self.hotels = []
  self.baseUrl = 'https://api.parse.com/1/classes/'

  self.count = ->
    promise = $http.get(self.baseUrl + 'hotel' + '?count=1&limit=0')

  self.all = (refresh) ->
    if self.hotels.length == 0 || refresh
      promise = $http.get(self.baseUrl + 'hotel')
        .then (response) ->
          #clear array
          while (self.hotels.length > 0)
            self.hotels.pop()
          response.data.results.forEach (hotel) ->
            self.hotels.push(Entity.fromJSON(hotel))
          self.hotels
        .catch (error) -> $log.error(error)
      self.hotels['$promise'] = promise
    else
      deferred = $q.defer()
      deferred.resolve(self.hotels)
      self.hotels['$promise'] = deferred.promise
    self.hotels

  self.getById = (id, refresh) ->
    index = null
    # from server
    if self.hotels.length == 0 || !_.find(self.hotels, (hotel) -> hotel.objectId == id) || refresh
      index = _.findIndex(self.hotels, (hotel) -> hotel.objectId == id) if refresh # look up index for refreshing
      # if the id wasn't found in cache, we insert the empty object and keep the last index
      index = self.hotels.push({}) - 1 if index == -1 || index == null
      promise = $http.get(self.baseUrl + 'hotel/' + id)
        .then (response) ->
          angular.extend(self.hotels[index], Entity.fromJSON(response.data))
          self.hotels[index]
        .catch (error) -> $log.error(error)
      self.hotels[index]['$promise'] = promise
    # cache hit
    else
      deferred = $q.defer()
      index = _.findIndex(self.hotels, (hotel) -> hotel.objectId == id)
      deferred.resolve(self.hotels[index])
      self.hotels[index]['$promise'] = deferred.promise
    self.hotels[index]

  self.save = (hotel) ->
    promise = null
    if !hotel.objectId  # the object is a new one
      promise = $http.post(self.baseUrl + 'hotel', hotel)
        .then (response) ->
          hotel.objectId = response.data.objectId
          self.hotels.push(hotel)
        .catch (error) -> $log.error(error)
    else # updating the object
      promise = $http.put(self.baseUrl + 'hotel/' + hotel.objectId, hotel)
    promise

  self.remove = (hotel) ->
    index = _.findIndex(self.hotels, (t) -> hotel.objectId == t.objectId)
    $http.delete(self.baseUrl + 'hotel/' + hotel.objectId).then (response) ->
      self.hotels.splice(index, 1)

  self

