describe 'Tours controller', ->
  tours = [{ objectId: 1, title: 't1', text: 'text', countryId: 1, hotelId: 1, placeId: 1 },
           { objectId: 1, title: 't2', text: 'text', countryId: 2, hotelId: 2, placeId: 2 }]
  hotels = [{ objectId: 1, name: 'hotel1' }, { objectId: 2, name: 'hotel2' }]
  countries = [{ objectId: 1, name: 'country1' }, { objectId: 2, name: 'country2' }]
  places = [{ objectId: 1, name: 'place', countryId: 1 }, { objectId: 2, name: 'place2', countryId: 2 }]
  
  beforeEach -> module('voyageVoyage')
  
  describe 'Init', ->
    t = {}
    # мокаем PersistenceService 
    beforeEach(inject ($controller, _PersistenceService_, _$q_, _$timeout_) ->
      $q = _$q_
      t.$scope = {}
      t.PersistenceService = _PersistenceService_
      t.$timeout = _$timeout_

      spyOn(t.PersistenceService, 'loadResource').and.callFake (resName) ->
        deferred = $q.defer()
        result = {}
        switch resName
          when 'tour' then deferred.resolve(tours)
          when 'country' then deferred.resolve(countries)
          when 'hotel' then deferred.resolve(hotels)
          when 'place' then deferred.resolve(places)
        result.$promise = deferred.promise
        result
        
      tourController = $controller 'ToursController', {
        $scope: t.$scope,
        PersistenceService: t.PersistenceService}
    )

    it 'sets $scope correctly', ->
      t.$timeout.flush()
      expect(t.$scope.tours).toBe(tours)
      expect(t.$scope.countries).toEqual(countries)
      expect(t.$scope.hotels).toBe(hotels)
      expect(t.$scope.places).toBe(places)


    it 'calls PersistenceService', ->
      t.$timeout.flush()
      expect(t.PersistenceService.loadResource).toHaveBeenCalledWith('tour')
      expect(t.PersistenceService.loadResource).toHaveBeenCalledWith('country')
      expect(t.PersistenceService.loadResource).toHaveBeenCalledWith('hotel')
      expect(t.PersistenceService.loadResource).toHaveBeenCalledWith('place')

  describe 'filters', ->
    t = {}
    beforeEach(inject ($controller, _$httpBackend_, _PersistenceService_, _$timeout_, $q) ->
      t.$scope = {}
      t.$timeout = _$timeout_
      t.PersistenceService = _PersistenceService_
      t.$httpBackend = _$httpBackend_
      ['tour', 'country', 'hotel'].forEach (res) ->
        url = "https://api.parse.com/1/classes/#{res}"
        t.$httpBackend.whenGET(url).respond('[]')
      # allPlaces in the controller is a private member, so I can't set it in the test. I init it in the line below with GET
      t.$httpBackend.whenGET("https://api.parse.com/1/classes/place").respond(JSON.stringify({ results: places }))
      toursController = $controller 'ToursController', { $scope: t.$scope, PersistenceService: t.PersistenceService, $q: $q }
      t.$httpBackend.flush()
      t.$timeout.flush()
    )

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

    it 'filters places with selected country set', ->
      t.$scope.selectedCountry = countries[0]
      t.$scope.updatePlaceList()
      expect(t.$scope.places.length).toEqual(1)

    it 'doesnt filter places with selected country empty', ->
      t.$scope.selectedCountry = null
      t.$scope.updatePlaceList()
      expect(t.$scope.places.length).toEqual(2)

    afterEach ->
      t.$httpBackend.verifyNoOutstandingRequest()
      t.$timeout.verifyNoPendingTasks()
