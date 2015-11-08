describe 'Tour controller', ->
  t = {}
  tour = { objectId: 1, title: 't', text: 'text', countryId: 1, hotelId: 1, placeId: 1 }
  hotel = { objectId: 1, name: 'hotel' }
  country = { objectId: 1, name: 'country' }
  place = { objectId: 1, name: 'place' }
  
  beforeEach -> module('voyageVoyage')
  
  beforeEach(inject ($controller, _PersistenceService_, _$q_, _$timeout_, $rootScope) ->
    $q = _$q_
    t.$scope = $rootScope.$new()
    routeParams: { slug: 1 }
    @PersistenceService = _PersistenceService_
    @$timeout = _$timeout_

    spyOn(@PersistenceService, 'loadResourceById').and.callFake (resName, id) ->
      deferred = $q.defer()
      result = {}
      switch resName
        when 'tour' then deferred.resolve(tour)
        when 'country' then deferred.resolve(country)
        when 'hotel' then deferred.resolve(hotel)
        when 'place' then deferred.resolve(place)
      result.$promise = deferred.promise
      result
      
    tourController = $controller 'TourController', {
      $scope: t.$scope,
      $routeParams: { slug: 1 },
      PersistenceService: @PersistenceService}
  )

  it 'sets $scope correctly', ->
    t.$scope.$apply()
    expect(t.$scope.tour).toBe(tour)
    expect(t.$scope.country).toEqual(country)
    expect(t.$scope.hotel).toBe(hotel)
    expect(t.$scope.place).toBe(place)


  it 'calls PersistenceService', ->
    @$timeout.flush()
    expect(@PersistenceService.loadResourceById).toHaveBeenCalledWith('tour', 1)
    expect(@PersistenceService.loadResourceById).toHaveBeenCalledWith('country', 1)
    expect(@PersistenceService.loadResourceById).toHaveBeenCalledWith('hotel', 1)
    expect(@PersistenceService.loadResourceById).toHaveBeenCalledWith('place', 1)
