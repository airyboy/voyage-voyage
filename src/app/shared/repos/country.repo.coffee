angular.module('voyageVoyage').service 'CountryRepository', 
($http, $log, $q, Entity, _) ->
  self = {}

  self.countries = []
  self.baseUrl = 'https://api.parse.com/1/classes/'

  self.count = ->
    promise = $http.get(self.baseUrl + 'country' + '?count=1&limit=0')

  self.all = (refresh) ->
    if self.countries.length == 0 || refresh
      promise = $http.get(self.baseUrl + 'country')
        .then (response) ->
          #clear array
          while (self.countries.length > 0)
            self.countries.pop()
          response.data.results.forEach (country) ->
            self.countries.push(Entity.fromJSON(country))
          self.countries
        .catch (error) -> $log.error(error)
      self.countries['$promise'] = promise
    else
      deferred = $q.defer()
      deferred.resolve(self.countries)
      self.countries['$promise'] = deferred.promise
    self.countries

  self.getById = (id, refresh) ->
    index = null
    # from server
    if self.countries.length == 0 || !_.find(self.countries, (country) -> country.objectId == id) || refresh
      index = _.findIndex(self.countries, (country) -> country.objectId == id) if refresh # look up index for refreshing
      # if the id wasn't found in cache, we insert the empty object and keep the last index
      index = self.countries.push({}) - 1 if index == -1 || index == null
      promise = $http.get(self.baseUrl + 'country/' + id)
        .then (response) ->
          angular.extend(self.countries[index], Entity.fromJSON(response.data))
          self.countries[index]
        .catch (error) -> $log.error(error)
      self.countries[index]['$promise'] = promise
    # cache hit
    else
      deferred = $q.defer()
      index = _.findIndex(self.countries, (country) -> country.objectId == id)
      deferred.resolve(self.countries[index])
      self.countries[index]['$promise'] = deferred.promise
    self.countries[index]

  self.save = (country) ->
    promise = null
    if !country.objectId  # the object is a new one
      promise = $http.post(self.baseUrl + 'country', country)
        .then (response) ->
          country.objectId = response.data.objectId
          self.countries.push(country)
        .catch (error) -> $log.error(error)
    else # updating the object
      promise = $http.put(self.baseUrl + 'country/' + country.objectId, country)
    promise

  self.remove = (country) ->
    index = _.findIndex(self.countries, (t) -> country.objectId == t.objectId)
    $http.delete(self.baseUrl + 'country/' + country.objectId).then (response) ->
      self.countries.splice(index, 1)

  self

