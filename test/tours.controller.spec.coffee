describe  'Tours controller', ->
  t = {}
  tours = [{ objectId: 1, title: 't1', text: 'text', countryId: 1, hotelId: 1, placeId: 1 },
           { objectId: 1, title: 't2', text: 'text', countryId: 2, hotelId: 2, placeId: 2 }]
  hotels = [{ objectId: 1, name: 'hotel1' }, { objectId: 2, name: 'hotel2' }]
  countries = [{ objectId: 1, name: 'country1' }, { objectId: 2, name: 'country2' }]
  places = [{ objectId: 1, name: 'place', countryId: 1 }, { objectId: 2, name: 'place2', countryId: 2 }]
  
  beforeEach -> module('voyageVoyage')

  beforeEach(inject ($controller, $q, $rootScope, CountryRepository, HotelRepository, PlaceRepository, TourRepository) ->
    t.$scope = $rootScope.$new()
    t.TourRepository = TourRepository
    t.HotelRepository = HotelRepository
    t.PlaceRepository = PlaceRepository
    t.CountryRepository = CountryRepository

    spyOn(t.TourRepository, 'all').and.callFake ->
      deferred = $q.defer()
      deferred.resolve(tours)
      result = {}
      result['$promise'] = deferred.promise
      t.TourRepository.tours = tours
      result

    spyOn(t.HotelRepository, 'all').and.returnValue(hotels)
    spyOn(t.CountryRepository, 'all').and.returnValue(countries)
    spyOn(t.PlaceRepository, 'all').and.returnValue(places)
      
    tourController = $controller 'ToursController', {
      $scope: t.$scope,
      TourRepository: t.TourRepository,
      PlaceRepository: t.PlaceRepository,
      HotelRepository: t.HotelRepository,
      CountryRepository: t.CountryRepository }
  )
  
  it 'sets $scope correctly', ->
    t.$scope.$apply()
    expect(t.$scope.tours).toBe(tours)
    expect(t.$scope.countries).toEqual(countries)
    expect(t.$scope.hotels).toBe(hotels)
    expect(t.$scope.places).toBe(places)

  describe 'filters', ->
    it 'filters countries when selectedCountry is defined', ->
      t.$scope.selectedCountry = countries[0]
      expect(t.$scope.countryFilter(tours[1])).toBeFalsy()
      expect(t.$scope.countryFilter(tours[0])).toBeTruthy()
      
    it 'doesnt filter countries when selectedCountry is not defined', ->
      t.$scope.selectedCountry = null
      expect(t.$scope.countryFilter(tours[1])).toBeTruthy()
      expect(t.$scope.countryFilter(tours[0])).toBeTruthy()

    it 'filters places when selectedPlace is defined', ->
      t.$scope.selectedPlace = places[0]
      expect(t.$scope.placeFilter(tours[1])).toBeFalsy()
      expect(t.$scope.placeFilter(tours[0])).toBeTruthy()
      
    it 'doesnt filter places when selectedPlace is not defined', ->
      t.$scope.selectedPlace = null
      expect(t.$scope.placeFilter(tours[1])).toBeTruthy()
      expect(t.$scope.placeFilter(tours[0])).toBeTruthy()
