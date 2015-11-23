angular.module('voyageVoyage').service 'CountryRepository',
($http, $log, $q, Entity, _) ->
  self = {}

  self.countries = {}
  self.baseUrl = 'https://api.parse.com/1/classes/'

  self.count = ->
    promise = $http.get(self.baseUrl + 'country' + '?count=1&limit=0')

  self.all = (refresh) ->
    if Object.keys(self.all).length == 0 || refresh
      promise = $http.get(self.baseUrl + 'country')
        .then (response) ->
          response.data.results.forEach (country) ->
            self.countries[country.objectId] = Entity.fromJSON(country)
          self.countries
        .catch (error) -> $log.error(error)
      self.countries['$promise'] = promise
    else
      deferred = $q.defer()
      deferred.resolve(self.countries)
      self.countries['$promise'] = deferred.promise
    self.countries

  self.getById = (id, refresh) ->
    if !self.countries.hasOwnProperty(id) || refresh
      #from server
      self.countries[id] = {}
      promise = $http.get(self.baseUrl + "country/#{id}")
        .then (response) ->
          angular.extend(self.countries[id], Entity.fromJSON(response.data))
          self.countries[id]
        .catch (error) -> $log.error(error)
      self.countries[id]['$promise'] = promise
    else
      #cache hit
      deferred = $q.defer()
      deferred.resolve(self.countries[id])
      self.countries[id]['$promise'] = deferred.promise
    self.countries[id]

  self.save = (country) ->
    promise = null
    if !country.objectId
      # inserting the new object at the temporary key
      uniqueId = _.uniqueId()
      self.countries[uniqueId] = country
      promise = $http.post(self.baseUrl + 'country', country)
        .then (response) ->
          country.objectId = response.objectId
          self.countries[country.objectId] = country
          # removing the temporary object
          delete self.countries[uniqueId]
          self.countries[country.objectId]
        .catch (error) -> $log.error(error)
    else
      self.countries[country.objectId] = country
      promise = $http.put(self.baseUrl + "country/#{country.objectId}", country)
    promise

  self.remove = (country) ->
    promise = $http.delete(self.baseUrl + "country/#{country.objectId}")
      .then (response) ->
        delete self.countries[country.objectId] if self.countries[country.objectId]
      .catch (error) -> $log.error(error)
    promise

  self
