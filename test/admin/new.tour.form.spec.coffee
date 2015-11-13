describe 'Admin tours controller', ->
  t = {}

  beforeEach -> module('voyageVoyage')
  beforeEach -> module('vvDirectives')

  beforeEach inject ($compile, $rootScope, $templateCache) ->
    t.$scope = $rootScope.$new()
    template = angular.element($templateCache.get('app/admin/tours/index.html'))
    $compile(template)(t.$scope)
    t.$scope.$digest()
    t.form = t.$scope.form

  it 'should be invalid when all fields are empty', ->
    expect(t.form.$valid).toBeFalsy()

  it 'should be valid when all fields are valid', ->
    t.form.title.$setViewValue('some title')
    t.form.text.$setViewValue('some longer text')
    t.form.duration.$setViewValue('10')
    t.form.price.$setViewValue('1010')
    t.form.hotel.$setViewValue('1')
    t.form.country.$setViewValue('1')
    t.form.place.$setViewValue('1')
    expect(t.form.$valid).toBeTruthy()
