describe 'Resource factory', ->
  t = {}

  beforeEach -> module('voyageVoyage')

  beforeEach(inject (_$httpBackend_, _$timeout_, _ResourceFactory_) ->
    t.$httpBackend = _$httpBackend_
    t.$timeout = _$timeout_
    t.ResourceFactory = new _ResourceFactory_('res')
    t.url = 'https://api.parse.com/1/classes/res'

    t.$httpBackend.whenGET(t.url).respond(JSON.stringify({ results: [{ a: 'aa', b: 1 }, { a: 'bb', b: 2 }] }))
  )
    
  it 'has custom methods', ->
    expect(typeof t.ResourceFactory.query).toBe('function')
    expect(typeof t.ResourceFactory.update).toBe('function')
    expect(typeof t.ResourceFactory.getById).toBe('function')

  it 'requests the url needed', ->
    result = t.ResourceFactory.query()
    t.$httpBackend.flush()
    t.$timeout.flush()
    t.$httpBackend.expectGET(t.url)

  it 'transforms query response', ->
    result = t.ResourceFactory.query()
    t.$httpBackend.flush()
    t.$timeout.flush()
    expect(result[0].a).toEqual('aa')
    expect(result[0].b).toEqual(1)
    expect(result[1].a).toEqual('bb')
    expect(result[1].b).toEqual(2)
    
  it 'makes a correct PUT request', ->
    obj = { objectId: 1, a: 'aa' }
    resource = new t.ResourceFactory(obj)
    t.$httpBackend.whenPUT('https://api.parse.com/1/classes/res/1').respond(201)
    resource.$update()
    t.$httpBackend.flush()
    t.$timeout.flush()
    t.$httpBackend.expectPUT('https://api.parse.com/1/classes/res/1')
    
  it 'returns a correct single object on getById', ->
    obj = { objectId: 1, a: 'aa' }
    t.$httpBackend.whenGET('https://api.parse.com/1/classes/res/1').respond(JSON.stringify({ a: 'aa', objectId: 1 }))
    result = t.ResourceFactory.getById { objectId: 1 }
    t.$httpBackend.flush()
    t.$timeout.flush()
    t.$httpBackend.expectGET('https://api.parse.com/1/classes/res/1')
    expect(result.a).toBe('aa')
    expect(result.objectId).toBe(1)

  afterEach ->
    t.$httpBackend.verifyNoOutstandingRequest()
    t.$timeout.verifyNoPendingTasks()
