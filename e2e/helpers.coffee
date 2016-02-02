Helpers =
  selectRandom: (select) ->
    options = select.all(By.css('option'))
    options.count().then (num) ->
      index = Math.floor(Math.random() * num)
      options.get(index).click()

  errorMessage: (fieldName, errorType) ->
    selector = "[ng-messages='form.#{fieldName}.$error'] .error-message[ng-message=#{errorType}]"
    element(By.css(selector))

module.exports = Helpers
