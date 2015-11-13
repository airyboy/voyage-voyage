describe 'cutWords filter', ->
  cutWordsFilter = null

  beforeEach ->
    module 'voyageVoyage'
    inject (_cutWordsFilter_) ->
      cutWordsFilter = _cutWordsFilter_

  it 'cuts words', ->
    cut = cutWordsFilter('One two three four five six seven', 4)
    expect(cut).toBe('One two three four')

  it 'cuts punctuation from the end', ->
    cut = cutWordsFilter('One two three four. Five six seven', 4)
    expect(cut).toBe('One two three four')
