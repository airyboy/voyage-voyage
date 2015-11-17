describe 'Stars directive', ->
  t = {}

  directiveElement = ->
    html = "<vv-stars stars='{{ stars }}'>"
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
      t.$scope.stars = 5
      t.$scope.$digest()

    describe 'stars one-way binded', ->
      it 'sets stars', ->
        t.$scope.$digest()
        expect(+t.isolateScope.stars).toEqual(t.$scope.stars)

      it 'changes do not affect parent scope', ->
        t.isolateScope.stars = '3'
        t.$scope.$digest()
        expect(t.$scope.stars).not.toEqual(t.isolateScope.stars)

      it 'changes affect isolate scope', ->
        t.$scope.stars = '4'
        t.$scope.$digest()
        expect(t.isolateScope.stars).toEqual(t.$scope.stars)

  describe 'times func', ->
    it 'generates a correct array', ->
      expect(t.isolateScope.times(4)).toEqual([1, 2, 3, 4])

