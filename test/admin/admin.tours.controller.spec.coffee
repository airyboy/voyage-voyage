describe 'Admin tours controller', ->
  t = {}
  tours = [{ objectId: 1, title: 't1', text: 'text', countryId: 1, hotelId: 1, placeId: 1 },
           { objectId: 1, title: 't2', text: 'text', countryId: 2, hotelId: 2, placeId: 2 }]
  hotels = [{ objectId: 1, name: 'hotel1' }, { objectId: 2, name: 'hotel2' }]
  countries = [{ objectId: 1, name: 'country1' }, { objectId: 2, name: 'country2' }]
  places = [{ objectId: 1, name: 'place1', countryId: 1 }, { objectId: 2, name: 'place2', countryId: 2 }]
  
  beforeEach -> module('voyageVoyage')
   
  beforeEach(inject ($controller, $q, $rootScope, $window, Entity,
  CountryRepository, HotelRepository, PlaceRepository, TourRepository) ->
    t.$scope = $rootScope.$new()
    t.$q = $q
    t.$window = $window
    t.TourRepository = TourRepository
    t.HotelRepository = HotelRepository
    t.PlaceRepository = PlaceRepository
    t.CountryRepository = CountryRepository
    t.Entity = Entity

    spyOn(t.TourRepository, 'all').and.callFake ->
      deferred = $q.defer()
      deferred.resolve(tours)
      result = {}
      result['$promise'] = deferred.promise
      t.TourRepository.tours = tours
      result

    spyOn(t.HotelRepository, 'all').and.callFake ->
      deferred = $q.defer()
      deferred.resolve(hotels)
      result = {}
      result['$promise'] = deferred.promise
      t.HotelRepository.hotels = hotels
      result

    spyOn(t.CountryRepository, 'all').and.callFake ->
      deferred = $q.defer()
      deferred.resolve(countries)
      result = {}
      result['$promise'] = deferred.promise
      t.CountryRepository.countries = countries
      result

    spyOn(t.PlaceRepository, 'all').and.callFake ->
      deferred = $q.defer()
      deferred.resolve(places)
      result = {}
      result['$promise'] = deferred.promise
      t.PlaceRepository.places = places
      result

    tourController = $controller 'AdminToursController', {
      $scope: t.$scope,
      TourRepository: t.TourRepository,
      PlaceRepository: t.PlaceRepository,
      HotelRepository: t.HotelRepository,
      CountryRepository: t.CountryRepository })

  describe "the controller's initialization", ->
    it 'should set $scope correctly', ->
      t.$scope.$digest()
      expect(t.$scope.tours.length).toEqual(tours.length)
      expect(t.$scope.countries).toEqual(countries)
      expect(t.$scope.hotels).toEqual(hotels)
      expect(t.$scope.places).toEqual(places)

    it 'calls TourRepository', ->
      t.$scope.$digest()
      expect(t.TourRepository.all).toHaveBeenCalled()

    it 'calls HotelRepository', ->
      t.$scope.$digest()
      expect(t.HotelRepository.all).toHaveBeenCalled()

    it 'calls PlaceRepository', ->
      t.$scope.$digest()
      expect(t.PlaceRepository.all).toHaveBeenCalled()

    it 'calls CountryRepository', ->
      t.$scope.$digest()
      expect(t.CountryRepository.all).toHaveBeenCalled()
  
  describe 'CRUD', ->
    describe '$scope.add', ->
      beforeEach ->
        t.$scope.$digest()
        t.$scope.state.tour = t.Entity.fromJSON(tours[0])
        spyOn(t.TourRepository, 'save').and.callFake ->
          deferred = t.$q.defer()
          deferred.resolve({ objectId: 1 })
          deferred.promise
        spyOn(t.$scope, 'setState')

      it "calls the repository's save method", ->
        t.$scope.$digest()
        t.$scope.add()
        expect(t.TourRepository.save).toHaveBeenCalled()

      it 'sets browse state', ->
        t.$scope.add()
        t.$scope.$digest()
        expect(t.$scope.setState).toHaveBeenCalledWith('browse')

      describe 'image upload', ->
        beforeEach ->
          t.$scope.image = 'some'
          spyOn(t.$scope, 'upload').and.callFake ->
            deferred = t.$q.defer()
            deferred.resolve({ objectId: 1 })
            deferred.promise

        it 'in case image is specified it uploads it', ->
          t.$scope.add()
          t.$scope.$digest()
          expect(t.$scope.upload).toHaveBeenCalledWith(t.$scope.image, t.$scope.tour)

        it 'it saves tour again with image link', ->
          t.$scope.add()
          t.$scope.$digest()
          expect(t.TourRepository.save.calls.count()).toEqual(2)

        it 'sets browse state', ->
          t.$scope.add()
          t.$scope.$digest()
          expect(t.$scope.setState).toHaveBeenCalledWith('browse')
        
    describe '$scope.update', ->
      beforeEach ->
        t.$scope.$digest()
        tour = t.Entity.fromJSON(tours[0])
        t.$scope.setState('inlineEdit', tour, 0)
        spyOn(t.TourRepository, 'save').and.callFake ->
          deferred = t.$q.defer()
          deferred.resolve({ objectId: 1 })
          deferred.promise
        spyOn(t.$scope, 'setState')

      it 'sets browse state', ->
        t.$scope.update()
        t.$scope.$digest()
        expect(t.$scope.setState).toHaveBeenCalledWith('browse')

      it "calls the repository's save method", ->
        t.$scope.$digest()
        t.$scope.update()
        expect(t.TourRepository.save).toHaveBeenCalled()

    describe '$scope.remove', ->
      tour = null
      beforeEach ->
        tour = t.Entity.fromJSON(tours[0])
        spyOn(t.TourRepository, 'remove').and.callFake ->
          deferred = t.$q.defer()
          deferred.resolve()
          deferred.promise

      it 'should show a warning message', ->
        spyOn(t.$window, 'confirm').and.returnValue(true)
        t.$scope.remove(tour)
        expect(t.$window.confirm).toHaveBeenCalled()

      it "should call the repository's remove method if a user agrees", ->
        spyOn(t.$window, 'confirm').and.returnValue(true)
        t.$scope.$digest()
        t.$scope.remove(tour)
        expect(t.TourRepository.remove).toHaveBeenCalled()

      it "shouldn't call the repository's remove method if a user disagrees", ->
        spyOn(t.$window, 'confirm').and.returnValue(false)
        t.$scope.$digest()
        t.$scope.remove(tour)
        expect(t.TourRepository.remove).not.toHaveBeenCalled()

    describe '$scope.cancel', ->
      beforeEach -> t.$scope.setState('new')

      it 'cancels silently if no changes were made', ->
        spyOn(t.$scope.state, 'canCancel').and.returnValue(true)
        spyOn(t.$window, 'confirm').and.returnValue(true)
        t.$scope.cancel()
        expect(t.$window.confirm).not.toHaveBeenCalled()

      it 'asks user if there were changes', ->
        spyOn(t.$scope.state, 'canCancel').and.returnValue(false)
        spyOn(t.$window, 'confirm').and.returnValue(true)
        t.$scope.cancel()
        expect(t.$window.confirm).toHaveBeenCalled()
