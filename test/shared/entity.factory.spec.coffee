describe 'Entity', ->
  t = {}
  
  beforeEach -> module('voyageVoyage')
  
  beforeEach(inject (_Entity_) ->
    t.Entity = _Entity_
    t.theEntity = new t.Entity
    t.emptyEntity = t.Entity.fromJSON({ a: null, b: 0, c: '', d: undefined, f: -> true })
    t.nonEmptyEntity = t.Entity.fromJSON({ a: null, b: 1, c: '', d: undefined, f: -> true })
  )

  it 'should be defined', ->
    expect(typeof t.Entity).toBeDefined()

  it 'isEmpty() correct', ->
    expect(t.emptyEntity.isEmpty()).toBeTruthy()
    expect(t.nonEmptyEntity.isEmpty()).toBeFalsy()

  it 'should be initialized empty', ->
    expect(t.theEntity.isEmpty()).toBeTruthy()

  describe 'isEqual()', ->
    beforeEach ->
      t.someEntity = t.Entity.fromJSON { a: 'aaa', b: 1, c: null }
      t.equalEntity = t.Entity.fromJSON { a: 'aaa', b: 1, c: null }
      t.nonEqualEntity = t.Entity.fromJSON { a: 'aba', b: 2, c: null }

    it 'should be equal', ->
      expect(t.someEntity.isEqual(t.equalEntity)).toBeTruthy()

    it 'should not be equal', ->
      expect(t.someEntity.isEqual(t.nonEqualEntity)).toBeFalsy()
