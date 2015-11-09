describe 'Pager directive', ->
  t = {}

  directiveElement = ->
    html = "<vv-pager></vv-pager>"
    el = angular.element(html)
    compiledElement = t.$compile(el)
    t.$scope.$digest()
    linkedElement = compiledElement(t.$scope)

  beforeEach ->
    module 'voyageVoyage'
    module 'vvDirectives'
    inject ($compile, $rootScope) ->
      t.$compile = $compile
      t.$scope = $rootScope.$new()

    t.dirEl = directiveElement()

    
  it 'should render the element', ->
   expect(t.dirEl.html()).not.toEqual ""
  
  
