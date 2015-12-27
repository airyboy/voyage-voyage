AdmToursPage = require('./adm.tours.po')
Helpers = require('../helpers')
toursPage = null

fillFields = ->
  toursPage.form.title.sendKeys('A shiny new tour')
  toursPage.form.text.sendKeys('A shiny new not so long description.')
  toursPage.form.duration.sendKeys('7')
  Helpers.selectRandom(toursPage.form.country)
  Helpers.selectRandom(toursPage.form.place)
  Helpers.selectRandom(toursPage.form.hotel)
  toursPage.form.price.sendKeys('199000')

describe 'index', ->
  beforeEach ->
    toursPage = new AdmToursPage()
    toursPage.get()
    browser.sleep(3000) # wait for the BrowserSync notification to disappear
    toursPage.newButton.click()

  it 'should show an error message if the title field is empty', ->
    toursPage.form.title.click()
    toursPage.form.text.click()
    errorMessage = Helpers.errorMessage('title', 'required')
    expect(errorMessage.isDisplayed()).toBeTruthy()

  it 'should show an error message if the title field is short', ->
    toursPage.form.title.sendKeys('aa')
    toursPage.form.text.click()
    errorMessage = Helpers.errorMessage('title', 'minlength')
    expect(errorMessage.isDisplayed()).toBeTruthy()

  it 'should show an error message if the text field is empty', ->
    toursPage.form.text.click()
    toursPage.form.title.click()
    errorMessage = Helpers.errorMessage('text', 'required')
    expect(errorMessage.isDisplayed()).toBeTruthy()

  it 'should show an error message if the text field is short', ->
    toursPage.form.text.sendKeys('aa')
    toursPage.form.title.click()
    errorMessage = Helpers.errorMessage('text', 'minlength')
    expect(errorMessage.isDisplayed()).toBeTruthy()

  it 'should show an error message if the duration field is empty', ->
    toursPage.form.duration.click()
    toursPage.form.title.click()
    errorMessage = Helpers.errorMessage('duration', 'required')
    expect(errorMessage.isDisplayed()).toBeTruthy()

  it 'should show an error message if the price field is empty', ->
    toursPage.form.price.click()
    toursPage.form.title.click()
    errorMessage = Helpers.errorMessage('price', 'required')
    expect(errorMessage.isDisplayed()).toBeTruthy()

  it 'should show an error message if the country field has a default option', ->
    toursPage.form.country.click()
    toursPage.form.title.click()
    errorMessage = Helpers.errorMessage('country', 'required')
    expect(errorMessage.isDisplayed()).toBeTruthy()

  it 'should show an error message if the place field has a default option', ->
    toursPage.form.place.click()
    toursPage.form.title.click()
    errorMessage = Helpers.errorMessage('place', 'required')
    expect(errorMessage.isDisplayed()).toBeTruthy()

  it 'should show an error message if the hotel field has a default option', ->
    toursPage.form.hotel.click()
    toursPage.form.title.click()
    errorMessage = Helpers.errorMessage('hotel', 'required')
    expect(errorMessage.isDisplayed()).toBeTruthy()
    
  it 'the submit button should be disabled initially', ->
    expect(toursPage.form.submit.isEnabled()).toBeFalsy()

  it 'should enable the submit button', ->
    fillFields()
    expect(toursPage.form.submit.isEnabled()).toBeTruthy()

  it 'should show a new tour after the form submitting', ->
    toursPage.tours().count().then (num) ->
      toursCountBefore = num

      fillFields()
      toursPage.form.submit.click()

      toursPage.tours().count().then (num) ->
        toursCountAfter = num
        expect(toursCountAfter - toursCountBefore).toEqual(1)
