class AdmToursPage
  constructor: ->
    @newButton = element(By.css('.top-row a.btn'))
    @form =
      title: element(By.css('form[name=form]')).element(By.css('input[name=title]'))
      text: element(By.css('form[name=form]')).element(By.css('textarea[name=text]'))
      country: element(By.css('form[name=form]')).element(By.css('select[name=country]'))
      place: element(By.css('form[name=form]')).element(By.css('select[name=place]'))
      hotel: element(By.css('form[name=form]')).element(By.css('select[name=hotel]'))
      duration: element(By.css('form[name=form]')).element(By.css('input[name=duration]'))
      price: element(By.css('form[name=form]')).element(By.css('input[name=price]'))
      submit: element(By.css('form[name=form]')).element(By.css('button[type=submit]'))

  get: ->
    browser.get 'http://localhost:3000/admin'
    @

  tours: -> element.all(By.repeater('tour in tours'))

module.exports = AdmToursPage

