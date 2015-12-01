describe 'Tour controller', ->
  t = {}
  tour = { objectId: 1, title: 't', text: 'text', countryId: 1, hotelId: 1, placeId: 1 }
  hotel = { objectId: 1, name: 'hotel' }
  country = { objectId: 1, name: 'country' }
  place = { objectId: 1, name: 'place' }
  
  beforeEach -> module('voyageVoyage')
  
  beforeEach(inject ($controller, $q, $rootScope, CountryRepository, HotelRepository, PlaceRepository, TourRepository) ->
    t.$scope = $rootScope.$new()
    routeParams: { slug: 1 }
    t.TourRepository = TourRepository
    t.HotelRepository = HotelRepository
    t.PlaceRepository = PlaceRepository
    t.CountryRepository = CountryRepository
    
    spyOn(t.TourRepository, 'getById').and.callFake (id) ->
      deferred = $q.defer()
      deferred.resolve(tour)
      result = {}
      result['$promise'] = deferred.promise
      result

    spyOn(t.HotelRepository, 'getById').and.returnValue(hotel)
    spyOn(t.CountryRepository, 'getById').and.returnValue(country)
    spyOn(t.PlaceRepository, 'getById').and.returnValue(place)
      
    tourController = $controller 'TourController', {
      $scope: t.$scope,
      $routeParams: { slug: 1 },
      TourRepository: t.TourRepository,
      PlaceRepository: t.PlaceRepository,
      HotelRepository: t.HotelRepository,
      CountryRepository: t.CountryRepository }
  )

  it 'sets $scope correctly', ->
    t.$scope.$apply()
    expect(t.$scope.tour).toBe(tour)
    expect(t.$scope.country).toEqual(country)
    expect(t.$scope.hotel).toBe(hotel)
    expect(t.$scope.place).toBe(place)
