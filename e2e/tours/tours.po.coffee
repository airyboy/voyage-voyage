class ToursPage
  get: ->
    browser.get 'http://localhost:3000/'
    @

  tours: element.all(By.repeater('tour in tours'))
  countryFilter: element(By.model('selectedCountry'))
  countryFilterOptions: element(By.model('selectedCountry')).all(By.tagName('li'))
  placeFilter: element(By.model('selectedPlace'))

module.exports = ToursPage
