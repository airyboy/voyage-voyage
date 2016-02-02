ToursPage = require('./tours.po')
toursPage = null

describe 'index', ->
  beforeEach ->
    toursPage = new ToursPage()
    toursPage.get()

  it 'should load tours', ->
    tours = toursPage.tours #element.all(By.repeater('tour in tours'))
    expect(tours.count()).toBeGreaterThan(0)

  it 'should filter by country', ->
    toursPage.countryFilter.click()
    el = toursPage.countryFilterOptions.get(2)
    el.getText().then (countryName) ->
      el.click()

      reduceFunc = (acc, elem) ->
          elem.getText().then (text) ->
            acc && (text == countryName)
      areAllCountriesSame =
        toursPage
        .tours
        .all(By.css('vv-tour-link-filter[type="country"] span'))
        .reduce(reduceFunc, true)
       
      expect(areAllCountriesSame).toBeTruthy()
