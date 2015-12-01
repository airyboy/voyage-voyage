describe 'TourRepository', ->
  t = {}

  t.tours = [{objectId: 1, title: 'aaa'}, {objectId: 2, title: 'bbb'}]
  t.otherTours = [{objectId: 3, title: 'ccc'}, {objectId: 4, title: 'ddd'}]
  
  beforeEach -> module('voyageVoyage')

  beforeEach(inject ($rootScope, TourRepository, $httpBackend, Entity) ->
    t.$scope = $rootScope.$new()
    t.TourRepository = TourRepository
    t.$httpBackend = $httpBackend
    t.Entity = Entity )

  it 'should init an array to store data', ->
    expect(Array.isArray(t.TourRepository.tours)).toBeTruthy()
  it 'should have all method', ->
    expect(typeof t.TourRepository.all).toBe('function')
  it 'should have getById method', ->
    expect(typeof t.TourRepository.getById).toBe('function')
  it 'should have save method', ->
    expect(typeof t.TourRepository.save).toBe('function')
  it 'should have remove method', ->
    expect(typeof t.TourRepository.remove).toBe('function')

  describe 'all', ->
    describe 'when the tours array is empty', ->
      beforeEach ->
        t.getAll = t.$httpBackend.whenGET(t.TourRepository.baseUrl + 'tour').respond(JSON.stringify({ results: t.tours }))

      it 'should fetch the data from server', ->
        t.$httpBackend.expectGET(t.TourRepository.baseUrl + 'tour')
        t.TourRepository.all()
        t.$httpBackend.flush()
        t.$httpBackend.verifyNoOutstandingRequest()

      it 'should populate the tours array', ->
        t.TourRepository.all()
        t.$httpBackend.flush()
        expect(t.TourRepository.tours.length).toEqual(2)

      it 'should enclose a $promise in the array', ->
        expect(t.TourRepository.all().$promise).toBeDefined()

      it '$promise should return the tours array', ->
        tours = null
        t.TourRepository.all().$promise.then (response) ->
          tours = response
        t.$httpBackend.flush()
        expect(tours.length).toBe(2)
        
      it 'returns the tours array and it has been populated after a while', ->
        tours = t.TourRepository.all()
        expect(tours.length).toBe(0)
        t.$httpBackend.flush()
        expect(tours.length).toBe(2)
        expect(tours).toBe(t.TourRepository.tours)

      describe 'with refresh option', ->
        beforeEach -> t.TourRepository.all()
        it 'should clear the array and fetch the new data', ->
          t.getAll.respond(JSON.stringify({ results: t.otherTours }))
          t.TourRepository.all()
          t.$httpBackend.flush()
          expect(t.TourRepository.tours[0].objectId).toBe(3)
          expect(t.TourRepository.tours[1].objectId).toBe(4)

      describe 'when cached data', ->
        beforeEach ->
          t.TourRepository.all()
          t.$httpBackend.flush()

        it 'should not fetch data from server if it is not specified', ->
          t.$httpBackend.expectGET(t.TourRepository.baseUrl + 'tour')
          t.TourRepository.all()
          expect(t.$httpBackend.verifyNoOutstandingExpectation).toThrow()
          
        it 'should enclose a $promise in the array', ->
          expect(t.TourRepository.all().$promise).toBeDefined()

        it '$promise should return the tours array', ->
          tours = null
          t.TourRepository.all().$promise.then (response) ->
            tours = response
          t.$scope.$digest()
          expect(tours.length).toBe(2)

        it 'returns the tours array', ->
          tours = t.TourRepository.all()
          expect(tours).toBe(t.TourRepository.tours)

  describe 'getById', ->
    describe 'when non-cached data', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.TourRepository.baseUrl + 'tour/1').respond(JSON.stringify(t.tours[0]))

      it 'should return the tour and resolve it later', ->
        tour = t.TourRepository.getById(1)
        expect(tour.objectId).not.toBeDefined()
        t.$httpBackend.flush()
        expect(tour.objectId).toEqual(1)

      it 'should store the loaded tour in the tours array', ->
        expect(t.TourRepository.tours.length).toBe(0)
        tour = t.TourRepository.getById(1)
        t.$httpBackend.flush()
        expect(t.TourRepository.tours.length).toBe(1)

      it 'should enclose $promise in the tour', ->
        tour = t.TourRepository.getById(1)
        expect(tour.$promise).toBeDefined()

      it '$promise success callback should return the tour', ->
        tour = null
        t.TourRepository.getById(1).$promise.then (response) ->
          tour = response
        t.$httpBackend.flush()
        expect(tour.objectId).toBe(1)

      xit 'should wraps the tour into Entity class', ->
        tour = t.TourRepository.getById(1)
        t.$httpBackend.flush()
        expect(tour.constructor.name).toEqual('Entity')

    describe 'when cached data', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.TourRepository.baseUrl + 'tour').respond(JSON.stringify({ results: t.tours }))
        t.TourRepository.all()
        t.$httpBackend.flush()

      it 'should enclose $promise in the tour', ->
        tour = t.TourRepository.getById(1)
        expect(tour.$promise).toBeDefined()

      it 'should not fetch the tour from server', ->
        t.$httpBackend.expectGET(t.TourRepository.baseUrl + 'tour/1')
        t.TourRepository.getById(1)
        expect(t.$httpBackend.verifyNoOutstandingExpectation).toThrow()
        
      it '$promise success callback should return the tour', ->
        tour = null
        t.TourRepository.getById(1).$promise.then (response) ->
          tour = response
        t.$scope.$digest()
        expect(tour.objectId).toBe(1)

  describe 'save', ->
    describe 'when a new object', ->
      beforeEach ->
        t.$httpBackend.whenPOST(t.TourRepository.baseUrl + 'tour').respond(200, JSON.stringify({ objectId: 5 }))
        t.$httpBackend.expectPOST(t.TourRepository.baseUrl + 'tour')
      it 'should send a POST request to the server', ->
        tour = { title: 'new' }
        t.TourRepository.save(tour)
        t.$httpBackend.flush()
        expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()

      it 'should add the object to the tours array', ->
        tour = { title: 'new' }
        expect(t.TourRepository.tours.length).toBe(0)
        t.TourRepository.save(tour)
        t.$httpBackend.flush()
        expect(t.TourRepository.tours.length).toBe(1)

      it 'should set objectId property of the object', ->
        tour = { title: 'new' }
        expect(tour.objectId).not.toBeDefined()
        t.TourRepository.save(tour)
        t.$httpBackend.flush()
        expect(tour.objectId).toBeDefined()

      it 'should return a promise object', ->
        tour = { title: 'new' }
        result = t.TourRepository.save(tour)
        expect(result.constructor.name).toEqual('Promise')

    describe 'when an existing object', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.TourRepository.baseUrl + 'tour').respond(JSON.stringify({ results: t.tours }))
        t.TourRepository.all()
        t.$httpBackend.flush()

      it 'should send a PUT request to the server', ->
        t.$httpBackend.whenPUT(t.TourRepository.baseUrl + 'tour/1').respond(201)
        tour = t.TourRepository.tours[0]
        tour.title = 'eee'
        t.$httpBackend.expectPUT(t.TourRepository.baseUrl + 'tour/1')
        t.TourRepository.save(tour)
        t.$httpBackend.flush()
        expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()
        
      it 'should return a promise object', ->
        tour = t.TourRepository.tours[0]
        result = t.TourRepository.save(tour)
        expect(result.constructor.name).toEqual('Promise')

  describe 'remove', ->
    beforeEach ->
      t.$httpBackend.whenGET(t.TourRepository.baseUrl + 'tour').respond(JSON.stringify({ results: t.tours }))
      t.TourRepository.all()
      t.$httpBackend.flush()
      t.$httpBackend.whenDELETE(t.TourRepository.baseUrl + 'tour/1').respond(200)

    it 'should make a DELETE request to the server', ->
      tour = t.TourRepository.tours[0]
      t.TourRepository.remove(tour)
      t.$httpBackend.expectDELETE(t.TourRepository.baseUrl + 'tour/1')
      expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()

    it 'should remove the tour from the tours array', ->
      expect(t.TourRepository.tours.length).toBe(2)
      tour = t.TourRepository.tours[0]
      t.TourRepository.remove(tour)
      t.$httpBackend.flush()
      expect(t.TourRepository.tours.length).toBe(1)

    it 'should return a promise object', ->
      tour = t.TourRepository.tours[0]
      result = t.TourRepository.remove(tour)
      expect(result.constructor.name).toEqual('Promise')
