describe 'Entity', ->
  setup = {}
  
  beforeEach -> module('voyageVoyage')
  
  beforeEach(inject (_Entity_) ->
    setup.Entity = _Entity_
    setup.theEntity = new setup.Entity
    setup.emptyEntity = setup.Entity.fromJSON({ a: null, b: 0, c: '', d: undefined, f: -> true })
    setup.nonEmptyEntity = setup.Entity.fromJSON({ a: null, b: 1, c: '', d: undefined, f: -> true })
  )

  it 'should be defined', ->
    expect(typeof setup.Entity).toBeDefined()

  it 'isEmpty() correct', ->
    expect(setup.emptyEntity.isEmpty()).toBeTruthy()
    expect(setup.nonEmptyEntity.isEmpty()).toBeFalsy()

  it 'should be initialized empty', ->
    expect(setup.theEntity.isEmpty()).toBe 1

  describe 'isEqual()', ->
    beforeEach ->
      setup.someEntity = setup.Entity.fromJSON { a: 'aaa', b: 1, c: null }
      setup.equalEntity = setup.Entity.fromJSON { a: 'aaa', b: 1, c: null }
      setup.nonEqualEntity = setup.Entity.fromJSON { a: 'aba', b: 2, c: null }

    it 'should be equal', ->
      expect(setup.someEntity.isEqual(setup.equalEntity)).toBeTruthy()

    it 'should not be equal', ->
      expect(setup.someEntity.isEqual(setup.nonEqualEntity)).toBeFalsy()
