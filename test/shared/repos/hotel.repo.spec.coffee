describe 'HotelRepository', ->
  t = {}

  t.hotels = [{objectId: 1, title: 'aaa'}, {objectId: 2, title: 'bbb'}]
  t.otherHotels = [{objectId: 3, title: 'ccc'}, {objectId: 4, title: 'ddd'}]
  
  beforeEach -> module('voyageVoyage')

  beforeEach(inject ($rootScope, HotelRepository, $httpBackend, Entity) ->
    t.$scope = $rootScope.$new()
    t.HotelRepository = HotelRepository
    t.$httpBackend = $httpBackend
    t.Entity = Entity )

  it 'should init an array to store data', ->
    expect(Array.isArray(t.HotelRepository.hotels)).toBeTruthy()
  it 'should have all method', ->
    expect(typeof t.HotelRepository.all).toBe('function')
  it 'should have getById method', ->
    expect(typeof t.HotelRepository.getById).toBe('function')
  it 'should have save method', ->
    expect(typeof t.HotelRepository.save).toBe('function')
  it 'should have remove method', ->
    expect(typeof t.HotelRepository.remove).toBe('function')

  describe 'all', ->
    describe 'when the hotels array is empty', ->
      beforeEach ->
        t.getAll = t.$httpBackend.whenGET(t.HotelRepository.baseUrl + 'hotel').respond(JSON.stringify({ results: t.hotels }))

      it 'should fetch the data from server', ->
        t.$httpBackend.expectGET(t.HotelRepository.baseUrl + 'hotel')
        t.HotelRepository.all()
        t.$httpBackend.flush()
        t.$httpBackend.verifyNoOutstandingRequest()

      it 'should populate the hotels array', ->
        t.HotelRepository.all()
        t.$httpBackend.flush()
        expect(t.HotelRepository.hotels.length).toEqual(2)

      it 'should enclose a $promise in the array', ->
        expect(t.HotelRepository.all().$promise).toBeDefined()

      it '$promise should return the hotels array', ->
        hotels = null
        t.HotelRepository.all().$promise.then (response) ->
          hotels = response
        t.$httpBackend.flush()
        expect(hotels.length).toBe(2)
        
      it 'returns the hotels array and it has been populated after a while', ->
        hotels = t.HotelRepository.all()
        expect(hotels.length).toBe(0)
        t.$httpBackend.flush()
        expect(hotels.length).toBe(2)
        expect(hotels).toBe(t.HotelRepository.hotels)

      describe 'with refresh option', ->
        beforeEach -> t.HotelRepository.all()
        it 'should clear the array and fetch the new data', ->
          t.getAll.respond(JSON.stringify({ results: t.otherHotels }))
          t.HotelRepository.all()
          t.$httpBackend.flush()
          expect(t.HotelRepository.hotels[0].objectId).toBe(3)
          expect(t.HotelRepository.hotels[1].objectId).toBe(4)

      describe 'when cached data', ->
        beforeEach ->
          t.HotelRepository.all()
          t.$httpBackend.flush()

        it 'should not fetch data from server if it is not specified', ->
          t.$httpBackend.expectGET(t.HotelRepository.baseUrl + 'hotel')
          t.HotelRepository.all()
          expect(t.$httpBackend.verifyNoOutstandingExpectation).toThrow()
          
        it 'should enclose a $promise in the array', ->
          expect(t.HotelRepository.all().$promise).toBeDefined()

        it '$promise should return the hotels array', ->
          hotels = null
          t.HotelRepository.all().$promise.then (response) ->
            hotels = response
          t.$scope.$digest()
          expect(hotels.length).toBe(2)

        it 'returns the hotels array', ->
          hotels = t.HotelRepository.all()
          expect(hotels).toBe(t.HotelRepository.hotels)

  describe 'getById', ->
    describe 'when non-cached data', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.HotelRepository.baseUrl + 'hotel/1').respond(JSON.stringify(t.hotels[0]))

      it 'should return the hotel and resolve it later', ->
        hotel = t.HotelRepository.getById(1)
        expect(hotel.objectId).not.toBeDefined()
        t.$httpBackend.flush()
        expect(hotel.objectId).toEqual(1)

      it 'should store the loaded hotel in the hotels array', ->
        expect(t.HotelRepository.hotels.length).toBe(0)
        hotel = t.HotelRepository.getById(1)
        t.$httpBackend.flush()
        expect(t.HotelRepository.hotels.length).toBe(1)

      it 'should enclose $promise in the hotel', ->
        hotel = t.HotelRepository.getById(1)
        expect(hotel.$promise).toBeDefined()

      it '$promise success callback should return the hotel', ->
        hotel = null
        t.HotelRepository.getById(1).$promise.then (response) ->
          hotel = response
        t.$httpBackend.flush()
        expect(hotel.objectId).toBe(1)

      xit 'should wraps the hotel into Entity class', ->
        hotel = t.HotelRepository.getById(1)
        t.$httpBackend.flush()
        expect(hotel.constructor.name).toEqual('Entity')

    describe 'when cached data', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.HotelRepository.baseUrl + 'hotel').respond(JSON.stringify({ results: t.hotels }))
        t.HotelRepository.all()
        t.$httpBackend.flush()

      it 'should enclose $promise in the hotel', ->
        hotel = t.HotelRepository.getById(1)
        expect(hotel.$promise).toBeDefined()

      it 'should not fetch the hotel from server', ->
        t.$httpBackend.expectGET(t.HotelRepository.baseUrl + 'hotel/1')
        t.HotelRepository.getById(1)
        expect(t.$httpBackend.verifyNoOutstandingExpectation).toThrow()
        
      it '$promise success callback should return the hotel', ->
        hotel = null
        t.HotelRepository.getById(1).$promise.then (response) ->
          hotel = response
        t.$scope.$digest()
        expect(hotel.objectId).toBe(1)

  describe 'save', ->
    describe 'when a new object', ->
      beforeEach ->
        t.$httpBackend.whenPOST(t.HotelRepository.baseUrl + 'hotel').respond(200, JSON.stringify({ objectId: 5 }))
        t.$httpBackend.expectPOST(t.HotelRepository.baseUrl + 'hotel')
      it 'should send a POST request to the server', ->
        hotel = { title: 'new' }
        t.HotelRepository.save(hotel)
        t.$httpBackend.flush()
        expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()

      it 'should add the object to the hotels array', ->
        hotel = { title: 'new' }
        expect(t.HotelRepository.hotels.length).toBe(0)
        t.HotelRepository.save(hotel)
        t.$httpBackend.flush()
        expect(t.HotelRepository.hotels.length).toBe(1)

      it 'should set objectId property of the object', ->
        hotel = { title: 'new' }
        expect(hotel.objectId).not.toBeDefined()
        t.HotelRepository.save(hotel)
        t.$httpBackend.flush()
        expect(hotel.objectId).toBeDefined()

      it 'should return a promise object', ->
        hotel = { title: 'new' }
        result = t.HotelRepository.save(hotel)
        expect(result.constructor.name).toEqual('Promise')

    describe 'when an existing object', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.HotelRepository.baseUrl + 'hotel').respond(JSON.stringify({ results: t.hotels }))
        t.HotelRepository.all()
        t.$httpBackend.flush()

      it 'should send a PUT request to the server', ->
        t.$httpBackend.whenPUT(t.HotelRepository.baseUrl + 'hotel/1').respond(201)
        hotel = t.HotelRepository.hotels[0]
        hotel.title = 'eee'
        t.$httpBackend.expectPUT(t.HotelRepository.baseUrl + 'hotel/1')
        t.HotelRepository.save(hotel)
        t.$httpBackend.flush()
        expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()
        
      it 'should return a promise object', ->
        hotel = t.HotelRepository.hotels[0]
        result = t.HotelRepository.save(hotel)
        expect(result.constructor.name).toEqual('Promise')

  describe 'remove', ->
    beforeEach ->
      t.$httpBackend.whenGET(t.HotelRepository.baseUrl + 'hotel').respond(JSON.stringify({ results: t.hotels }))
      t.HotelRepository.all()
      t.$httpBackend.flush()
      t.$httpBackend.whenDELETE(t.HotelRepository.baseUrl + 'hotel/1').respond(200)

    it 'should make a DELETE request to the server', ->
      hotel = t.HotelRepository.hotels[0]
      t.HotelRepository.remove(hotel)
      t.$httpBackend.expectDELETE(t.HotelRepository.baseUrl + 'hotel/1')
      expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()

    it 'should remove the hotel from the hotels array', ->
      expect(t.HotelRepository.hotels.length).toBe(2)
      hotel = t.HotelRepository.hotels[0]
      t.HotelRepository.remove(hotel)
      t.$httpBackend.flush()
      expect(t.HotelRepository.hotels.length).toBe(1)

    it 'should return a promise object', ->
      hotel = t.HotelRepository.hotels[0]
      result = t.HotelRepository.remove(hotel)
      expect(result.constructor.name).toEqual('Promise')
