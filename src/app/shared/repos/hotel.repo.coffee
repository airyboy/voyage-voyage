angular.module('voyageVoyage').service 'HotelRepository',
($http, $log, $q, Entity, _) ->
  self = {}

  self.hotels = {}
  self.baseUrl = 'https://api.parse.com/1/classes/'

  self.count = ->
    promise = $http.get(self.baseUrl + 'hotel' + '?count=1&limit=0')

  self.all = (refresh) ->
    if Object.keys(self.all).length == 0 || refresh
      promise = $http.get(self.baseUrl + 'hotel')
        .then (response) ->
          response.data.results.forEach (hotel) ->
            self.hotels[hotel.objectId] = Entity.fromJSON(hotel)
          self.hotels
        .catch (error) -> $log.error(error)
      self.hotels['$promise'] = promise
    else
      deferred = $q.defer()
      deferred.resolve(self.hotels)
      self.hotels['$promise'] = deferred.promise
    self.hotels

  self.getById = (id, refresh) ->
    if !self.hotels.hasOwnProperty(id) || refresh
      #from server
      self.hotels[id] = {}
      promise = $http.get(self.baseUrl + "hotel/#{id}")
        .then (response) ->
          angular.extend(self.hotels[id], Entity.fromJSON(response.data))
          self.hotels[id]
        .catch (error) -> $log.error(error)
      self.hotels[id]['$promise'] = promise
    else
      #cache hit
      deferred = $q.defer()
      deferred.resolve(self.hotels[id])
      self.hotels[id]['$promise'] = deferred.promise
    self.hotels[id]

  self.save = (hotel) ->
    promise = null
    if !hotel.objectId
      uniqueId = _.uniqueId()
      self.hotels[uniqueId] = hotel
      promise = $http.post(self.baseUrl + 'hotel', hotel)
        .then (response) ->
          hotel.objectId = response.objectId
          self.hotels[hotel.objectId] = hotel
          delete self.hotels[uniqueId]
          self.hotels[hotel.objectId]
        .catch (error) -> $log.error(error)
    else
      self.hotels[hotel.objectId] = hotel
      promise = $http.put(self.baseUrl + "hotel/#{hotel.objectId}", hotel)
    promise

  self.remove = (hotel) ->
    promise = $http.delete(self.baseUrl + "hotel/#{hotel.objectId}")
      .then (response) ->
        delete self.hotels[hotel.objectId] if self.hotels[hotel.objectId]
      .catch (error) -> $log.error(error)
    promise

  self
