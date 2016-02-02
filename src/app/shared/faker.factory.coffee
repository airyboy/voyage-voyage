angular.module("voyageVoyage").factory "NewFakerFactory", (_) ->
  class Seeds
    constructor: ->
      @countryPlace =
        'Argentina': ['Buenos Aires', 'Aconcagua', 'Ushuaia', 'Mendoza']
        'Brazil': ['Rio de Janeiro', 'Iguacu Falls', 'Amazon River']
        'France': ['Paris', 'Bordeaux']
        'Czech Republic': ['Prague', 'Kutna Hora', 'Baden Baden']
        'Japan': ['Tokyo', 'Sapporo']
        'Switzerland': ['Montreux', 'Matterhorn', 'Geneva']
        'Germany': ['Munich', 'Berlin', 'Neuschwanstein']
        'Russia': ['St Petersburg', 'Kazan', 'Baikal Lake']
      @duration = '3,5,7,10,14,21'
      @hotel = 'Four Seasons,Hyatt,Radisson,Kempinski,Marriot,Mandarin Oriental,Hilton'
      @star = '2,3,4,5'
      @adjective = 'Gorgeous,Incredible,Brilliant,Stunning,Heartbreaking,Picturesque,Entertaining,Impressive,Remarkable'
      @duration = '3,5,7,10,14,21'
      @hotel = 'Four Seasons,Hyatt,Radisson,Kempinski,Marriot,Mandarin Oriental,Hilton'
      @star = '2,3,4,5'
      @text = [
        'The LORD is my shepherd; I shall not want. He makes me lie down in gre' +
        'en pastures. He leads me beside still waters. He restores my soul. He ' +
        'leads me in paths of righteousness for his name’s sake. Even though I ' +
        'walk through the valley of the shadow of death, I will fear no evil, f' +
        'or you are with me; your rod and your staff, they comfort me. You prep' +
        'are a table before me in the presence of my enemies; you anoint my hea' +
        'd with oil; my cup overflows. Surelyd goodness and mercye shall follow' +
        ' me all the days of my life, and I shall dwellf in the house of the LO' +
        'RD forever.',
        'Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusa' +
        'ntium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab ill' +
        'o inventore veritatis et quasi architecto beatae vitae dicta sunt, exp' +
        'licabo. Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut ' +
        'odit aut fugit, sed quia consequuntur magni dolores eos, qui ratione v' +
        'oluptatem sequi nesciunt, neque porro quisquam est, qui dolorem ipsum,' +
        ' quia dolor sit, amet, consectetur, adipisci velit, sed quia non numqu' +
        'am eius modi tempora incidunt, ut labore et dolore magnam aliquam quae' +
        'rat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ' +
        'ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi cons' +
        'equatur? Quis autem vel eum iure reprehenderit, qui in ea voluptate ve' +
        'lit esse, quam nihil molestiae consequatur, vel illum, qui dolorem eum' +
        ' fugiat, quo voluptas nulla pariatur? At vero eos et accusamus et iust' +
        'o odio dignissimos ducimus, qui blanditiis praesentium voluptatum dele' +
        'niti atque corrupti, quos dolores et quas molestias excepturi sint, ob' +
        'caecati cupiditate non provident, similique sunt in culpa, qui officia' +
        ' deserunt mollitia animi, id est laborum et dolorum fuga. Et harum qui' +
        'dem rerum facilis est et expedita distinctio. Nam libero tempore, cum ' +
        'soluta nobis est eligendi optio, cumque nihil impedit, quo minus id, q' +
        'uod maxime placeat, facere possimus, omnis voluptas assumenda est, omn' +
        'is dolor repellendus. Temporibus autem quibusdam et aut officiis debit' +
        'is aut rerum necessitatibus saepe eveniet, ut et voluptates repudianda' +
        'e sint et molestiae non recusandae. Itaque earum rerum hic tenetur a s' +
        'apiente delectus, ut aut reiciendis voluptatibus maiores alias consequ' +
        'atur aut perferendis doloribus asperiores repellat.']

  randomItem = (arr) ->
    idx = Math.floor(Math.random() * arr.length)
    arr[idx]
      
  countriesList = ->
    gen = new Seeds
    _.keys(gen.countryPlace)
    
  placesList = (countries) ->
    gen = new Seeds
    reduceFunc = (acc, country) ->
      found = _.find(countries, (ctr) -> ctr.name == country)
      if found
        _.each(gen.countryPlace[country], (place) -> acc.push({ countryId: found.objectId, name: place }))
      acc
      
    console.log _.keys(gen.countryPlace)
    _.keys(gen.countryPlace).reduce(reduceFunc, [])

  hotelsList = ->
    gen = new Seeds
    gen.hotel.split(',').map (obj) ->
      stars: +(randomItem(gen.star.split(',')))
      name: obj

  tourFaker = (refs) ->
    gen = new Seeds
    tours = []

    console.log refs.places[74]
    console.log new Date(refs.places[74].createdAt)
    console.log new Date(2016, 0, 1)
    console.log new Date(refs.places[74].createdAt) > new Date(2016, 1, 1)
    places = refs.places.filter (place) -> (new Date(place.createdAt) > new Date(2016, 0, 1))
    console.log places

    placesInRandomOrder = _.sample(places, places.length)

    findTourImages = (name) ->
      console.log name
      _.find(refs.tour_images, (ti) -> ti.image_name == name.toLowerCase())

    _.each placesInRandomOrder, (place) ->
      hotel = randomItem(refs.hotels)
      adj = randomItem(gen.adjective.split ',')
      title = "#{adj} #{place.name}"
      price = 10000 * (Math.floor(Math.random() * 15) + 5) - 100

      tours.push
        title: title
        text: randomItem gen.text
        placeId: place.objectId
        countryId: place.countryId
        hotelId: hotel.objectId
        duration: +(randomItem gen.duration.split(','))
        image: findTourImages(place.name).fileName
        price: price
    tours
  faker = ->
    @countries = new countriesList
    @hotels = new hotelsList
    @places = placesList
    @tours = tourFaker
    return

  return new faker
