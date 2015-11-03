describe 'Admin tours controller', ->
  tours = [{ objectId: 1, title: 't1', text: 'text', countryId: 1, hotelId: 1, placeId: 1 },
           { objectId: 1, title: 't2', text: 'text', countryId: 2, hotelId: 2, placeId: 2 }]
  hotels = [{ objectId: 1, name: 'hotel1' }, { objectId: 2, name: 'hotel2' }]
  countries = [{ objectId: 1, name: 'country1' }, { objectId: 2, name: 'country2' }]
  places = [{ objectId: 1, name: 'place1', countryId: 1 }, { objectId: 2, name: 'place2', countryId: 2 }]
  
  beforeEach -> module('voyageVoyage')
  
  describe 'Init controller', ->
    t = {}

    beforeEach(inject ($controller, _PersistenceService_, _$q_, _$timeout_, _Entity_, _TourStateFactory_) ->
      $q = _$q_
      t.$scope = {}
      t.PersistenceService = _PersistenceService_
      t.$timeout = _$timeout_
      t.Entity = _Entity_
      t.TourStateFactory = _TourStateFactory_

      # мокаем PersistenceService 
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
        
      toursController = $controller 'AdminToursController', {
        $scope: t.$scope,
        TourStateFactory: t.TourStateFactory,
        Entity: _Entity_,
        $q: $q,
        PersistenceService: t.PersistenceService }
    )

    it 'sets $scope correctly', ->
      t.$timeout.flush()
      expect(t.$scope.tours.length).toEqual(tours.length)
      expect(t.$scope.countries).toEqual(countries)
      expect(t.$scope.hotels).toEqual(hotels)
      expect(t.$scope.places).toEqual(places)


    it 'calls PersistenceService', ->
      t.$timeout.flush()
      ['tour', 'country', 'hotel', 'place'].forEach (res) ->
        expect(t.PersistenceService.loadResource).toHaveBeenCalledWith(res)

  describe 'CRUD', ->
    t = {}
   
    beforeEach(inject ($controller, _PersistenceService_, _$timeout_, _$httpBackend_, _Entity_, _$window_) ->
      t.$scope = {}
      t.PersistenceService = _PersistenceService_
      t.$timeout = _$timeout_
      t.$httpBackend = _$httpBackend_
      t.Entity = _Entity_
      t.window = _$window_

      tourController = $controller 'AdminToursController', {
        $scope: t.$scope,
        PersistenceService: t.PersistenceService}
        
      ['tour', 'country', 'hotel', 'place'].forEach (res) ->
        url = "https://api.parse.com/1/classes/#{res}"
        t.$httpBackend.whenGET(url).respond('[]')

      t.$httpBackend.flush()
    )

    it '$scope.add saves resource, pushes to array and set browse state', ->
      # init
      t.$scope.state.tour = t.Entity.fromJSON(tours[0])
      # check 
      spyOn(t.$scope.tours, 'push').and.callThrough()
      spyOn(t.PersistenceService, 'saveResource')
      spyOn(t.$scope, 'setState')
      t.$scope.add()
      expect(t.PersistenceService.saveResource).toHaveBeenCalled()
      expect(t.$scope.setState).toHaveBeenCalledWith('browse')
      expect(t.$scope.tours.push).toHaveBeenCalled()
      expect(t.$scope.tours.length).toBe(1)
     
    it '$scope.update', ->
      # init
      tour = t.Entity.fromJSON(tours[0])
      t.$scope.tours.push t.Entity.fromJSON(tours[0])
      t.$scope.setState('inlineEdit', tour, 0)
      # check 
      spyOn(t.PersistenceService, 'saveResource').and.stub
      spyOn(t.$scope, 'setState')
      tour.text = 'new text'
      t.$scope.update()
      expect(t.PersistenceService.saveResource).toHaveBeenCalled()
      expect(t.$scope.setState).toHaveBeenCalledWith('browse')

    it '$scope.remove', ->
      # init
      tour = t.Entity.fromJSON(tours[0])
      t.$scope.tours.push t.Entity.fromJSON(tours[0])
      # check 
      spyOn(t.window, 'confirm').and.returnValue(true)
      spyOn(t.PersistenceService, 'removeResource').and.stub
      t.$scope.remove(0)
      expect(t.window.confirm).toHaveBeenCalled()
      expect(t.PersistenceService.removeResource).toHaveBeenCalled()
      expect(t.$scope.tours.length).toBe(0)

    describe '$scope.cancel', ->
      beforeEach -> t.$scope.setState('new')

      it 'cancels silently if no changes were made', ->
        spyOn(t.$scope.state, 'canCancel').and.returnValue(true)
        spyOn(t.window, 'confirm').and.returnValue(true)
        t.$scope.cancel()
        expect(t.window.confirm).not.toHaveBeenCalled()

      it 'asks user if there were changes', ->
        spyOn(t.$scope.state, 'canCancel').and.returnValue(false)
        spyOn(t.window, 'confirm').and.returnValue(true)
        t.$scope.cancel()
        expect(t.window.confirm).toHaveBeenCalled()
