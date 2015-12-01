describe 'CountryRepository', ->
  t = {}

  t.countries = [{objectId: 1, title: 'aaa'}, {objectId: 2, title: 'bbb'}]
  t.otherCountrys = [{objectId: 3, title: 'ccc'}, {objectId: 4, title: 'ddd'}]
  
  beforeEach -> module('voyageVoyage')

  beforeEach(inject ($rootScope, CountryRepository, $httpBackend, Entity) ->
    t.$scope = $rootScope.$new()
    t.CountryRepository = CountryRepository
    t.$httpBackend = $httpBackend
    t.Entity = Entity )

  it 'should init an array to store data', ->
    expect(Array.isArray(t.CountryRepository.countries)).toBeTruthy()
  it 'should have all method', ->
    expect(typeof t.CountryRepository.all).toBe('function')
  it 'should have getById method', ->
    expect(typeof t.CountryRepository.getById).toBe('function')
  it 'should have save method', ->
    expect(typeof t.CountryRepository.save).toBe('function')
  it 'should have remove method', ->
    expect(typeof t.CountryRepository.remove).toBe('function')

  describe 'all', ->
    describe 'when the countries array is empty', ->
      beforeEach ->
        t.getAll = t.$httpBackend.whenGET(t.CountryRepository.baseUrl + 'country').respond(JSON.stringify({ results: t.countries }))

      it 'should fetch the data from server', ->
        t.$httpBackend.expectGET(t.CountryRepository.baseUrl + 'country')
        t.CountryRepository.all()
        t.$httpBackend.flush()
        t.$httpBackend.verifyNoOutstandingRequest()

      it 'should populate the countries array', ->
        t.CountryRepository.all()
        t.$httpBackend.flush()
        expect(t.CountryRepository.countries.length).toEqual(2)

      it 'should enclose a $promise in the array', ->
        expect(t.CountryRepository.all().$promise).toBeDefined()

      it '$promise should return the countries array', ->
        countries = null
        t.CountryRepository.all().$promise.then (response) ->
          countries = response
        t.$httpBackend.flush()
        expect(countries.length).toBe(2)
        
      it 'returns the countries array and it has been populated after a while', ->
        countries = t.CountryRepository.all()
        expect(countries.length).toBe(0)
        t.$httpBackend.flush()
        expect(countries.length).toBe(2)
        expect(countries).toBe(t.CountryRepository.countries)

      describe 'with refresh option', ->
        beforeEach -> t.CountryRepository.all()
        it 'should clear the array and fetch the new data', ->
          t.getAll.respond(JSON.stringify({ results: t.otherCountrys }))
          t.CountryRepository.all()
          t.$httpBackend.flush()
          expect(t.CountryRepository.countries[0].objectId).toBe(3)
          expect(t.CountryRepository.countries[1].objectId).toBe(4)

      describe 'when cached data', ->
        beforeEach ->
          t.CountryRepository.all()
          t.$httpBackend.flush()

        it 'should not fetch data from server if it is not specified', ->
          t.$httpBackend.expectGET(t.CountryRepository.baseUrl + 'country')
          t.CountryRepository.all()
          expect(t.$httpBackend.verifyNoOutstandingExpectation).toThrow()
          
        it 'should enclose a $promise in the array', ->
          expect(t.CountryRepository.all().$promise).toBeDefined()

        it '$promise should return the countries array', ->
          countries = null
          t.CountryRepository.all().$promise.then (response) ->
            countries = response
          t.$scope.$digest()
          expect(countries.length).toBe(2)

        it 'returns the countries array', ->
          countries = t.CountryRepository.all()
          expect(countries).toBe(t.CountryRepository.countries)

  describe 'getById', ->
    describe 'when non-cached data', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.CountryRepository.baseUrl + 'country/1').respond(JSON.stringify(t.countries[0]))

      it 'should return the country and resolve it later', ->
        country = t.CountryRepository.getById(1)
        expect(country.objectId).not.toBeDefined()
        t.$httpBackend.flush()
        expect(country.objectId).toEqual(1)

      it 'should store the loaded country in the countries array', ->
        expect(t.CountryRepository.countries.length).toBe(0)
        country = t.CountryRepository.getById(1)
        t.$httpBackend.flush()
        expect(t.CountryRepository.countries.length).toBe(1)

      it 'should enclose $promise in the country', ->
        country = t.CountryRepository.getById(1)
        expect(country.$promise).toBeDefined()

      it '$promise success callback should return the country', ->
        country = null
        t.CountryRepository.getById(1).$promise.then (response) ->
          country = response
        t.$httpBackend.flush()
        expect(country.objectId).toBe(1)

      xit 'should wraps the country into Entity class', ->
        country = t.CountryRepository.getById(1)
        t.$httpBackend.flush()
        expect(country.constructor.name).toEqual('Entity')

    describe 'when cached data', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.CountryRepository.baseUrl + 'country').respond(JSON.stringify({ results: t.countries }))
        t.CountryRepository.all()
        t.$httpBackend.flush()

      it 'should enclose $promise in the country', ->
        country = t.CountryRepository.getById(1)
        expect(country.$promise).toBeDefined()

      it 'should not fetch the country from server', ->
        t.$httpBackend.expectGET(t.CountryRepository.baseUrl + 'country/1')
        t.CountryRepository.getById(1)
        expect(t.$httpBackend.verifyNoOutstandingExpectation).toThrow()
        
      it '$promise success callback should return the country', ->
        country = null
        t.CountryRepository.getById(1).$promise.then (response) ->
          country = response
        t.$scope.$digest()
        expect(country.objectId).toBe(1)

  describe 'save', ->
    describe 'when a new object', ->
      beforeEach ->
        t.$httpBackend.whenPOST(t.CountryRepository.baseUrl + 'country').respond(200, JSON.stringify({ objectId: 5 }))
        t.$httpBackend.expectPOST(t.CountryRepository.baseUrl + 'country')
      it 'should send a POST request to the server', ->
        country = { title: 'new' }
        t.CountryRepository.save(country)
        t.$httpBackend.flush()
        expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()

      it 'should add the object to the countries array', ->
        country = { title: 'new' }
        expect(t.CountryRepository.countries.length).toBe(0)
        t.CountryRepository.save(country)
        t.$httpBackend.flush()
        expect(t.CountryRepository.countries.length).toBe(1)

      it 'should set objectId property of the object', ->
        country = { title: 'new' }
        expect(country.objectId).not.toBeDefined()
        t.CountryRepository.save(country)
        t.$httpBackend.flush()
        expect(country.objectId).toBeDefined()

      it 'should return a promise object', ->
        country = { title: 'new' }
        result = t.CountryRepository.save(country)
        expect(result.constructor.name).toEqual('Promise')

    describe 'when an existing object', ->
      beforeEach ->
        t.$httpBackend.whenGET(t.CountryRepository.baseUrl + 'country').respond(JSON.stringify({ results: t.countries }))
        t.CountryRepository.all()
        t.$httpBackend.flush()

      it 'should send a PUT request to the server', ->
        t.$httpBackend.whenPUT(t.CountryRepository.baseUrl + 'country/1').respond(201)
        country = t.CountryRepository.countries[0]
        country.title = 'eee'
        t.$httpBackend.expectPUT(t.CountryRepository.baseUrl + 'country/1')
        t.CountryRepository.save(country)
        t.$httpBackend.flush()
        expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()
        
      it 'should return a promise object', ->
        country = t.CountryRepository.countries[0]
        result = t.CountryRepository.save(country)
        expect(result.constructor.name).toEqual('Promise')

  describe 'remove', ->
    beforeEach ->
      t.$httpBackend.whenGET(t.CountryRepository.baseUrl + 'country').respond(JSON.stringify({ results: t.countries }))
      t.CountryRepository.all()
      t.$httpBackend.flush()
      t.$httpBackend.whenDELETE(t.CountryRepository.baseUrl + 'country/1').respond(200)

    it 'should make a DELETE request to the server', ->
      country = t.CountryRepository.countries[0]
      t.CountryRepository.remove(country)
      t.$httpBackend.expectDELETE(t.CountryRepository.baseUrl + 'country/1')
      expect(t.$httpBackend.verifyNoOutstandingExpectation).not.toThrow()

    it 'should remove the country from the countries array', ->
      expect(t.CountryRepository.countries.length).toBe(2)
      country = t.CountryRepository.countries[0]
      t.CountryRepository.remove(country)
      t.$httpBackend.flush()
      expect(t.CountryRepository.countries.length).toBe(1)

    it 'should return a promise object', ->
      country = t.CountryRepository.countries[0]
      result = t.CountryRepository.remove(country)
      expect(result.constructor.name).toEqual('Promise')
