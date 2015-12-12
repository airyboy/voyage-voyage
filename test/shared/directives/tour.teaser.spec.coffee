describe 'Tour teaser directive', ->
  t = {}

  directiveElement = ->
    html = "<vv-tour-teaser>"
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
      t.$rootScope = $rootScope
    t.dirEl = directiveElement()
    t.isolateScope = t.dirEl.isolateScope()

  describe 'scope change', ->
    beforeEach ->
      t.$rootScope.$broadcast('tour.new', { title: 't', url: 'url', price: 100 })

    it 'should modify scope.title on the tour.new event', ->
      expect(t.isolateScope.title).toBe('t')

    it 'should modify scope.url on the tour.new event', ->
      expect(t.isolateScope.url).toBe('url')

    it 'should modify scope.price on the tour.new event', ->
      expect(t.isolateScope.price).toEqual(100)
