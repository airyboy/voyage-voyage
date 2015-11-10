describe 'Pager directive', ->
  t = {}

  directiveElement = ->
    html = "<vv-pager current-page='currentPage' page-size='{{ pageSize }}' total-items='{{ totalItems }}' page-changed='onPageChanged(page)'></vv-pager>"
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

  describe 'isolate scope', ->
    beforeEach ->
      t.$scope.currentPage = {page: 1}
      t.$scope.pageSize = '5'
      t.$scope.totalItems = '10'
      t.$scope.$digest()

    describe 'current page', ->
      it 'sets current page', ->
        t.$scope.$digest()
        expect(t.isolateScope.currentPage).toBe(t.$scope.currentPage)

      it 'changes affect parent scope', ->
        t.isolateScope.currentPage = {page:4}
        t.$scope.$digest()
        expect(t.$scope.currentPage).toEqual(t.isolateScope.currentPage)

      it 'changes affect isolate scope', ->
        t.$scope.currentPage = {page:3}
        t.$scope.$digest()
        expect(t.isolateScope.currentPage).toEqual(t.$scope.currentPage)

    describe 'page size', ->
      it 'sets page size', ->
        t.$scope.$digest()
        expect(t.isolateScope.pageSize).toEqual(t.$scope.pageSize)

      it 'changes do not affect parent scope', ->
        t.isolateScope.pageSize = '3'
        t.$scope.$digest()
        expect(t.$scope.pageSize).not.toEqual(t.isolateScope.pageSize)

      it 'changes affect isolate scope', ->
        t.$scope.pageSize = '6'
        t.$scope.$digest()
        expect(t.isolateScope.pageSize).toEqual(t.$scope.pageSize)

    describe 'totalItems', ->
      it 'sets totalItems', ->
        t.$scope.$digest()
        expect(t.isolateScope.totalItems).toEqual(t.$scope.totalItems)

      it 'changes do not affect parent scope', ->
        t.isolateScope.totalItems = '3'
        t.$scope.$digest()
        expect(t.$scope.totalItems).not.toEqual(t.isolateScope.totalItems)

      it 'changes affect isolate scope', ->
        t.$scope.totalItems = '6'
        t.$scope.$digest()
        expect(t.isolateScope.totalItems).toEqual(t.$scope.totalItems)
        
  describe 'totalPages', ->
    it 'calculates totalPages correctly', ->
      t.$scope.pageSize = '4'
      t.$scope.totalItems = '13'
      t.$scope.$digest()
      expect(t.isolateScope.totalPages).toBe(4)

    it 'generates a correct pages array', ->
      t.$scope.pageSize = '4'
      t.$scope.totalItems = '13'
      t.$scope.$digest()
      expect(t.isolateScope.pages).toEqual([1, 2, 3, 4])

  describe 'page change', ->
    beforeEach ->
      t.$scope.pageSize = 4
      t.$scope.totalItems = 13
      t.$scope.currentPage = 2
      t.$scope.$digest()

    it 'sets currentPage', ->
      t.isolateScope.setPage(2)
      expect(t.isolateScope.currentPage).toBe(2)

    it 'calls callback', ->
      spyOn(t.isolateScope, 'pageChangedCallback')
      t.isolateScope.setPage(2)
      expect(t.isolateScope.pageChangedCallback).toHaveBeenCalledWith({ page: 2})

    describe 'pageForward', ->
      it 'increments page if current page less than totalPages', ->
        t.isolateScope.pageForward()
        expect(t.isolateScope.currentPage).toBe(3)

      it 'doesn\'t increment page if current page equals totalPages', ->
        t.$scope.currentPage = 4
        t.$scope.$digest()
        t.isolateScope.pageForward()
        expect(t.isolateScope.currentPage).toBe(4)

      it 'calls callback', ->
        spyOn(t.isolateScope, 'pageChangedCallback')
        t.isolateScope.pageForward()
        expect(t.isolateScope.pageChangedCallback).toHaveBeenCalledWith({ page: 3})

    describe 'pageBackward', ->
      it 'decrements page if current page greater than 1', ->
        t.isolateScope.pageBackward()
        expect(t.isolateScope.currentPage).toBe(1)
        
      it 'doesn\'t decrement page if current page equals 1', ->
        t.$scope.currentPage = 1
        t.$scope.$digest()
        t.isolateScope.pageBackward()
        expect(t.isolateScope.currentPage).toBe(1)

      it 'calls callback', ->
        spyOn(t.isolateScope, 'pageChangedCallback')
        t.isolateScope.pageBackward()
        expect(t.isolateScope.pageChangedCallback).toHaveBeenCalledWith({ page: 1})

  describe 'page-changed callback', ->
    beforeEach ->
      t.$scope.onPageChanged = jasmine.createSpy('onPageChanged')

    it 'binds page-changed to a function', ->
      expect(typeof t.isolateScope.pageChangedCallback).toBe('function')

    it 'calls a function in a parent scope', ->
      t.isolateScope.pageChangedCallback({ page: 1})
      expect(t.$scope.onPageChanged).toHaveBeenCalledWith(1)
