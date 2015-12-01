describe 'PlaceRepository', ->
  t = {}

  t.places = [{objectId: 1, title: 'aaa'}, {objectId: 2, title: 'bbb'}]
  t.otherPlaces = [{objectId: 3, title: 'ccc'}, {objectId: 4, title: 'ddd'}]
  
  beforeEach -> module('voyageVoyage')

  beforeEach(inject ($rootScope, PlaceRepository, $httpBackend, Entity) ->
    t.$scope = $rootScope.$new()
    t.PlaceRepository = PlaceRepository
    t.$httpBackend = $httpBackend
    t.Entity = Entity )

  it 'should init an array to store data', ->
    expect(Array.isArray(t.PlaceRepository.places)).toBeTruthy()
  it 'should have all method', ->
    expect(typeof t.PlaceRepository.all).toBe('function')
  it 'should have getById method', ->
    expect(typeof t.PlaceRepository.getById).toBe('function')
  it 'should have save method', ->
    expect(typeof t.PlaceRepository.save).toBe('function')
  it 'should have remove method', ->
    expect(typeof t.PlaceRepository.remove).toBe('function')

  describe 'all', ->
    describe 'when the places array is empty', ->
      beforeEach ->
        t.getAll = t.$httpBackend.whenGET(t.PlaceRepository.baseUrl + 'place').respond(JSON.stringify({ results: t.places }))

      it 'should fetch the data from server', ->
        t.$httpBackend.expectGET(t.PlaceRepository.baseUrl + 'place')
        t.PlaceRepository.all()
        t.$httpBackend.flush()
        t.$httpBackend.verifyNoOutstandingRequest()

      it 'should populate the places array', ->
        t.PlaceRepository.all()
        t.$httpBackend.flush()
        expect(t.PlaceRepository.places.length).toEqual(2)

      it 'should enclose a $promise in the array', ->
        expect(t.PlaceRepository.all().$promise).toBeDefined()

      it '$promise should return the places array', ->
        places = null
        t.PlaceRepository.all().$promise.then (response) ->
          places = response
        t.$httpBackend.flush()
        expect(places.length).toBe(2)
        
      it 'returns the places array and it has been populated after a while', ->
        places = t.PlaceRepository.all()
        expect(places.length).toBe(0)
        t.$httpBackend.flush()
        expect(places.length).toBe(2)
        expect(places).toBe(t.PlaceRepository.places)

      describe 'with refresh option', ->
        beforeEach -> t.PlaceRepository.all()
        it 'should clear the array and fetch the new data', ->
          t.getAll.respond(JSON.stringify({ results: t.otherPlaces }))
          t.PlaceRepository.all()
          t.$httpBackend.flush()
          expect(t.PlaceRepository.places[0].objectId).toBe(3)
          expect(t.PlaceRepository.places[1].objectId).toBe(4)

      describe 'when cached data', ->
        beforeEach ->
          t.PlaceRepository.all()
          t.$httpBackend.flush()

        it 'should not fetch data from server if it is not specified', ->
          t.$httpBackend.expectGET(t.PlaceRepository.baseUrl + 'place')
          t.PlaceRepository.all()
          expect(t.$httpBackend.verifyNoOutstandingExpectation).toThrow()
          
        it 'should enclose a $promise in the array', ->
          expect(t.PlaceRepository.all().$promise).toBeDefined()

        it '$promise should return the places array', ->
          places = null
          t.PlaceRepository.all().$promise.then (response) ->
            places = response
          t.$scope.$digest()
          expect(places.length).toBe(2)

        it 'returns the places array', ->
          places = t.PlaceRepository.all()
          expect(places).toBe(t.PlaceRepository.places)

  describe 'getById', ->
    describe 'when non-cached data', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.PlaceRepository.baseUrl + 'place/1').respond(JSON.stringify(t.places[0]))

      it 'should return the place and resolve it later', ->
        place = t.PlaceRepository.getById(1)
        expect(place.objectId).not.toBeDefined()
        t.$httpBackend.flush()
        expect(place.objectId).toEqual(1)

      it 'should store the loaded place in the places array', ->
        expect(t.PlaceRepository.places.length).toBe(0)
        place = t.PlaceRepository.getById(1)
        t.$httpBackend.flush()
        expect(t.PlaceRepository.places.length).toBe(1)

      it 'should enclose $promise in the place', ->
        place = t.PlaceRepository.getById(1)
        expect(place.$promise).toBeDefined()

      it '$promise success callback should return the place', ->
        place = null
        t.PlaceRepository.getById(1).$promise.then (response) ->
          place = response
        t.$httpBackend.flush()
        expect(place.objectId).toBe(1)

      xit 'should wraps the place into Entity class', ->
        place = t.PlaceRepository.getById(1)
        t.$httpBackend.flush()
        expect(place.constructor.name).toEqual('Entity')

    describe 'when cached data', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.PlaceRepository.baseUrl + 'place').respond(JSON.stringify({ results: t.places }))
        t.PlaceRepository.all()
        t.$httpBackend.flush()

      it 'should enclose $promise in the place', ->
        place = t.PlaceRepository.getById(1)
        expect(place.$promise).toBeDefined()

      it 'should not fetch the place from server', ->
        t.$httpBackend.expectGET(t.PlaceRepository.baseUrl + 'place/1')
        t.PlaceRepository.getById(1)
        expect(t.$httpBackend.verifyNoOutstandingExpectation).toThrow()
        
      it '$promise success callback should return the place', ->
        place = null
        t.PlaceRepository.getById(1).$promise.then (response) ->
          place = response
        t.$scope.$digest()
        expect(place.objectId).toBe(1)

  describe 'save', ->
    describe 'when a new object', ->
      beforeEach ->
        t.$httpBackend.whenPOST(t.PlaceRepository.baseUrl + 'place').respond(200, JSON.stringify({ objectId: 5 }))
        t.$httpBackend.expectPOST(t.PlaceRepository.baseUrl + 'place')
      it 'should send a POST request to the server', ->
        place = { title: 'new' }
        t.PlaceRepository.save(place)
        t.$httpBackend.flush()
        expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()

      it 'should add the object to the places array', ->
        place = { title: 'new' }
        expect(t.PlaceRepository.places.length).toBe(0)
        t.PlaceRepository.save(place)
        t.$httpBackend.flush()
        expect(t.PlaceRepository.places.length).toBe(1)

      it 'should set objectId property of the object', ->
        place = { title: 'new' }
        expect(place.objectId).not.toBeDefined()
        t.PlaceRepository.save(place)
        t.$httpBackend.flush()
        expect(place.objectId).toBeDefined()

      it 'should return a promise object', ->
        place = { title: 'new' }
        result = t.PlaceRepository.save(place)
        expect(result.constructor.name).toEqual('Promise')

    describe 'when an existing object', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.PlaceRepository.baseUrl + 'place').respond(JSON.stringify({ results: t.places }))
        t.PlaceRepository.all()
        t.$httpBackend.flush()

      it 'should send a PUT request to the server', ->
        t.$httpBackend.whenPUT(t.PlaceRepository.baseUrl + 'place/1').respond(201)
        place = t.PlaceRepository.places[0]
        place.title = 'eee'
        t.$httpBackend.expectPUT(t.PlaceRepository.baseUrl + 'place/1')
        t.PlaceRepository.save(place)
        t.$httpBackend.flush()
        expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()
        
      it 'should return a promise object', ->
        place = t.PlaceRepository.places[0]
        result = t.PlaceRepository.save(place)
        expect(result.constructor.name).toEqual('Promise')

  describe 'remove', ->
    beforeEach ->
      t.$httpBackend.whenGET(t.PlaceRepository.baseUrl + 'place').respond(JSON.stringify({ results: t.places }))
      t.PlaceRepository.all()
      t.$httpBackend.flush()
      t.$httpBackend.whenDELETE(t.PlaceRepository.baseUrl + 'place/1').respond(200)

    it 'should make a DELETE request to the server', ->
      place = t.PlaceRepository.places[0]
      t.PlaceRepository.remove(place)
      t.$httpBackend.expectDELETE(t.PlaceRepository.baseUrl + 'place/1')
      expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()

    it 'should remove the place from the places array', ->
      expect(t.PlaceRepository.places.length).toBe(2)
      place = t.PlaceRepository.places[0]
      t.PlaceRepository.remove(place)
      t.$httpBackend.flush()
      expect(t.PlaceRepository.places.length).toBe(1)

    it 'should return a promise object', ->
      place = t.PlaceRepository.places[0]
      result = t.PlaceRepository.remove(place)
      expect(result.constructor.name).toEqual('Promise')
