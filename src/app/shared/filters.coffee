angular.module("voyageVoyage").filter "cutWords", ->
  (input, wordsCount) ->
    regex = new RegExp "^(\\S+[ ,.:;-\\s]+){1,#{wordsCount}}", 'g'
    result = regex.exec(input)
    result[0].replace(/[- .,:;]+$/, '')

angular.module('voyageVoyage').filter 'filterBy', ->
  (hash, filterFunc) ->
    result = {}
    for id, tour of hash
      result[id] = tour if id[0] != '$' && filterFunc(tour)
    result
