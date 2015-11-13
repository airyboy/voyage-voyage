describe 'Tours filter directive', ->
  t = {}

  directiveElement = ->
    html = "<vv-tours-filter places='places' countries='countries' selected-stars='selectedStars' \
    selected-country='selectedCountry' selected-place='selectedPlace' \
    filter-changed='onFilterChanged()'></vv-tours-filter>"
    el = angular.element(html)
    compiledElement = t.$compile(el)(t.$scope)
    t.$scope.$digest()
    compiledElement

  beforeEach ->
    module 'voyageVoyage'
    module 'vvDirectives'
    inject ($compile, $rootScope) ->
      t.$compile = $compile
      t.$scope = $rootScope.$new()
    t.dirEl = directiveElement()
    t.isolateScope = t.dirEl.isolateScope()

  describe 'exists', ->
    it 'shouldn\'t be empty', ->
     expect(t.dirEl.html()).not.toEqual ""
    
    it 'should contain a repeater', ->
      repeater = t.dirEl.find '[ng-repeat]'
      expect(repeater).toBeDefined()

  describe 'init', ->
    it 'inits stars', ->
      expect(t.isolateScope.stars).toBeDefined()

    it 'stars is an array', ->
      expect(Array.isArray(t.isolateScope.stars)).toBeTruthy()

  describe 'isolate scope', ->
    beforeEach ->
      t.$scope.places = []
      t.$scope.countries = []
      t.$scope.selectedPlace = {objectId: 1}
      t.$scope.selectedCountry = {objectId: 1}
      t.$scope.$digest()

    describe 'selectedPlace two-way binded', ->
      it 'sets selectedPlace', ->
        expect(t.isolateScope.selectedPlace).toBe(t.$scope.selectedPlace)

      it 'changes affect parent scope', ->
        t.isolateScope.selectedPlace = {objectId: 4}
        t.$scope.$digest()
        expect(t.$scope.selectedPlace).toEqual(t.isolateScope.selectedPlace)

      it 'changes affect isolate scope', ->
        t.$scope.selectedPlace = {objectId: 3}
        t.$scope.$digest()
        expect(t.isolateScope.selectedPlace).toEqual(t.$scope.selectedPlace)

    describe 'selectedCountry two-way binded', ->
      it 'sets selectedCountry', ->
        expect(t.isolateScope.selectedCountry).toBe(t.$scope.selectedCountry)

      it 'changes affect parent scope', ->
        t.isolateScope.selectedCountry = {objectId: 4}
        t.$scope.$digest()
        expect(t.$scope.selectedCountry).toEqual(t.isolateScope.selectedCountry)

      it 'changes affect isolate scope', ->
        t.$scope.selectedCountry = {objectId: 3}
        t.$scope.$digest()
        expect(t.isolateScope.selectedCountry).toEqual(t.$scope.selectedCountry)

    describe 'selectedStars two-way binded', ->
      it 'sets selectedStars', ->
        expect(t.isolateScope.selectedStars).toBe(t.$scope.selectedStars)

      it 'changes affect parent scope', ->
        t.isolateScope.selectedStars = {val: 4}
        t.$scope.$digest()
        expect(t.$scope.selectedStars.val).toEqual(t.isolateScope.selectedStars.val)

      it 'changes affect isolate scope', ->
        t.$scope.selectedStars = {val: 3}
        t.$scope.$digest()
        expect(t.isolateScope.selectedStars.val).toEqual(t.$scope.selectedStars.val)

    describe 'places two-way binded', ->
      beforeEach ->
        t.$scope.places = [{ objectId: 1 }, { objectId: 2 }]
        t.$scope.countries = []
        t.$scope.$digest()

      it 'sets places', ->
        expect(t.isolateScope.places).toBe(t.$scope.places)

      it 'changes affect parent scope', ->
        t.isolateScope.places = [{ objectId: 4 }, { objectId: 5 }]
        t.$scope.$digest()
        expect(t.$scope.places).toEqual(t.isolateScope.places)

      it 'changes affect isolate scope', ->
        t.$scope.places =  [{ objectId: 8 }, { objectId: 9 }]
        t.$scope.$digest()
        expect(t.isolateScope.places).toEqual(t.$scope.places)

    describe 'countries two-way binded', ->
      beforeEach ->
        t.$scope.countries = [{ objectId: 1 }, { objectId: 2 }]
        t.$scope.$digest()

      it 'sets countries', ->
        expect(t.isolateScope.countries).toBe(t.$scope.countries)

      it 'changes affect parent scope', ->
        t.isolateScope.countries = [{ objectId: 4 }, { objectId: 5 }]
        t.$scope.$digest()
        expect(t.$scope.countries).toEqual(t.isolateScope.countries)

      it 'changes affect isolate scope', ->
        t.$scope.countries =  [{ objectId: 8 }, { objectId: 9 }]
        t.$scope.$digest()
        expect(t.isolateScope.countries).toEqual(t.$scope.countries)

  describe 'filter-changed callback', ->
    beforeEach ->
      t.$scope.onFilterChanged = jasmine.createSpy('onFilterChanged')

    it 'binds filter-changed to a function', ->
      expect(typeof t.isolateScope.filterChangedCallback).toBe('function')

    it 'calls a function in a parent scope', ->
      t.isolateScope.filterChangedCallback()
      expect(t.$scope.onFilterChanged).toHaveBeenCalled()

  describe 'reset filter', ->
    beforeEach ->
      t.isolateScope.selectedPlace = { objectId: 1 }
      t.isolateScope.selectedCountry = { objectId: 2 }
      t.isolateScope.selectedStars = { val: 5 }
      t.$scope.$digest()

    it 'resets country', ->
      expect(t.isolateScope.selectedCountry).toBeDefined()
      t.isolateScope.reset()
      expect(t.isolateScope.selectedCountry).toBeNull()

    it 'resets place', ->
      expect(t.isolateScope.selectedPlace).toBeDefined()
      t.isolateScope.reset()
      expect(t.isolateScope.selectedPlace).toBeNull()

    it 'resets stars', ->
      expect(t.isolateScope.selectedStars).toBeDefined()
      t.isolateScope.reset()
      expect(t.isolateScope.selectedStars).toBeNull()
