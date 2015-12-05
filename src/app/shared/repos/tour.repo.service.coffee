angular.module('voyageVoyage').service 'TourRepository', ($http, $log, $q, Entity, _) ->
  self = {}

  self.tours = []
  self.baseUrl = 'https://api.parse.com/1/classes/'

  self.count = ->
    promise = $http.get(self.baseUrl + 'tour' + '?count=1&limit=0')

  self.all = (refresh) ->
    if self.tours.length == 0 || refresh
      promise = $http.get(self.baseUrl + 'tour' + '?include=pics')
        .then (response) ->
          #clear array
          while (self.tours.length > 0)
            self.tours.pop()
          response.data.results.forEach (tour) ->
            self.tours.push(Entity.fromJSON(tour))
          self.tours
        .catch (error) -> $log.error(error)
      self.tours['$promise'] = promise
    else
      deferred = $q.defer()
      deferred.resolve(self.tours)
      self.tours['$promise'] = deferred.promise
    self.tours

  self.getById = (id, refresh) ->
    index = null
    # from server
    if self.tours.length == 0 || !_.find(self.tours, (tour) -> tour.objectId == id) || refresh
      index = _.findIndex(self.tours, (tour) -> tour.objectId == id) if refresh # look up index for refreshing
      # if the id wasn't found in cache, we insert the empty object and keep the last index
      index = self.tours.push({}) - 1 if index == -1 || index == null
      promise = $http.get(self.baseUrl + 'tour/' + id)
        .then (response) ->
          angular.extend(self.tours[index], Entity.fromJSON(response.data))
          self.tours[index]
        .catch (error) -> $log.error(error)
      self.tours[index]['$promise'] = promise
    # cache hit
    else
      deferred = $q.defer()
      index = _.findIndex(self.tours, (tour) -> tour.objectId == id)
      deferred.resolve(self.tours[index])
      self.tours[index]['$promise'] = deferred.promise
    self.tours[index]

  self.save = (tour) ->
    promise = null
    if !tour.objectId  # the object is a new one
      promise = $http.post(self.baseUrl + 'tour', tour)
        .then (response) ->
          tour.objectId = response.data.objectId
          self.tours.push(tour)
        .catch (error) -> $log.error(error)
    else # updating the object
      promise = $http.put(self.baseUrl + 'tour/' + tour.objectId, tour)
    promise

  self.addImage = (tour, imageName, imageUrl) ->
    tourImage = {fileName: {__type: 'File', name: imageName, url: imageUrl}}
    $http.post(self.baseUrl + 'tour_image', tourImage).then (response) ->
      objId = response.data.objectId
      imageAddObj =
        pics:
          __op: 'Add'
          objects: [imageUrl]
      $http.put(self.baseUrl + 'tour/' + tour.objectId, imageAddObj).then (response) ->
        tour.pics = response.data.pics

  self.remove = (tour) ->
    index = _.findIndex(self.tours, (t) -> tour.objectId == t.objectId)
    $http.delete(self.baseUrl + 'tour/' + tour.objectId).then (response) ->
      self.tours.splice(index, 1)

  self
