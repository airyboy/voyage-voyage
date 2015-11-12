angular.module("voyageVoyage").filter "cutWords", ->
  (input, wordsCount) ->
    regex = new RegExp "^(\\S+[ ,.:;-\\s]+){1,#{wordsCount}}", 'g'
    result = regex.exec(input)
    result[0].replace(/[- .,:;]+$/, '...')
