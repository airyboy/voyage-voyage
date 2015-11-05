angular.module("voyageVoyage").factory "FakerFactory", ->
  Seeds = ->
    @country = 'Аргентина,Бразилия,Франция,Чехия,Корея,Япония,Швейцария,Колумбия,Ботсвана,Германия'
    @adjective = 'Чарующая,Невероятная,Пугающая,Искрящаяся,Обычная,Скучная,Веселая,Зимняя,Летняя'
    @place = 'beach,mountains,trekking,city'
    @duration = '3,5,7,10,14,21'
    @hotel = 'Four Seasons,Hyatt,Radisson,Kempinski,Marriot,Mandarin Oriental,Hilton'
    @star = '2,3,4,5'
    @text = ["The LORD is my shepherd; I shall not want.He makes me lie down in green pastures.  He leads me beside still waters.  He restores my soul.  He leads me in paths of righteousness for his name’s sake. Even though I walk through the valley of the shadow of death, I will fear no evil, for you are with me; your rod and your staff, they comfort me. You prepare a table before me in the presence of my enemies; you anoint my head with oil; my cup overflows.  Surelyd goodness and mercye shall follow me all the days of my life, and I shall dwellf in the house of the LORD forever.",
      'Каледонская складчатость просветляет холодный рельеф. Нижнее течение непосредственно применяет бамбук. Очаг многовекового орошаемого земледелия оформляет памятник Средневековья, а также необходима справка о прививке против бешенства и результаты анализа на бешенство через 120 дней и за 30 дней до отъезда. В турецких банях не принято купаться раздетыми, поэтому из полотенца сооружают юбочку, а макрель вразнобой вызывает бальнеоклиматический курорт. Пейзажный парк берёт туристический коралловый риф. Здесь работали Карл Маркс и Владимир Ленин, но Тасмания вызывает официальный язык.',
      'Тюлень теоретически возможен. Восточно-Африканское плоскогорье, несмотря на то, что есть много бунгало для проживания, мгновенно. Субэкваториальный климат, несмотря на внешние воздействия, изменяем.',
      'Кампос-серрадос, несмотря на то, что есть много бунгало для проживания, жизненно поднимает попугай. Рекомендуется совершить прогулку на лодке по каналам города и Озеру Любви, однако не надо забывать, что материк применяет черный эль, здесь есть много ценных пород деревьев, таких как железное, красное, коричневое (лим), черное (гу), сандаловое деревья, бамбуки и другие виды. Волна пространственно связывает туристический ледостав.',
      'Акцентируется не красота садовой дорожки, а Южное полушарие входит городской пейзажный парк. Бельгия, в первом приближении, представляет собой утконос, для этого необходим заграничный паспорт, действительный в течение трех месяцев с момента завершения поездки со свободной страницей для визы. Альбатрос просветляет языковой Бахрейн. Портер применяет рельеф. Восточно-Африканское плоскогорье, как бы это ни казалось парадоксальным, берёт экскурсионный полярный круг. Бурное развитие внутреннего туризма привело Томаса Кука к необходимости организовать поездки за границу, при этом мохово-лишайниковая растительность применяет двухпалатный парламент.',
      'Провоз кошек и собак прекрасно иллюстрирует гидроузел. Селитра поднимает глубокий утконос. Наводнение погранично. Большое Медвежье озеро начинает Карибский бассейн. Для пользования телефоном-автоматом необходимы разменные монеты, однако оазисное земледелие вызывает парк Варошлигет. Санитарный и ветеринарный контроль входит растительный покров, в этот день в меню - щи из морепродуктов в кокосовой скорлупе.',
      'Великобритания, несмотря на внешние воздействия, параллельна. Здесь работали Карл Маркс и Владимир Ленин, но озеро Ньяса связывает крестьянский ураган, например, "вентилятор" обозначает "веер-ветер", "спичка" - "палочка-чирк-огонь". Винный фестиваль проходит в приусадебном музее Георгикон, там же черный эль сложен. Гвианский щит, несмотря на внешние воздействия, жизненно выбирает различный пингвин, но особой популярностью пользуются заведения подобного рода, сосредоточенные в районе Центральной площади и железнодорожного вокзала.']
    return
  randomItem = (arr) ->
    idx = Math.floor(Math.random() * arr.length)
    arr[idx]
      
  countriesList = ->
    gen = new Seeds
    gen.country.split(',').map (obj) ->
      name: obj
    
  placesList = (countries) ->
    gen = new Seeds
    places = []
    angular.forEach countries, (country) ->
      gen.place.split(',').forEach (place) ->
        places.push
          name: place
          countryId: country.objectId
          countryName: country.name
    places
  hotelsList = ->
    gen = new Seeds
    gen.hotel.split(',').map (obj) ->
      stars: +(randomItem(gen.star.split(',')))
      name: obj

  tourFaker = (number, refs) ->
    gen = new Seeds
    tours = []

    for num in [0..number - 1]
      country = randomItem(refs.countries)
      place = randomItem(refs.places)
      hotel = randomItem(refs.hotels)
      adj = randomItem(gen.adjective.split ',')
      title = "#{adj} #{country.name}"
      price = 10000 * (Math.floor(Math.random() * 15) + 5) - 100

      tours.push
        title: title
        text: randomItem gen.text
        placeId: place.objectId
        countryId: country.objectId
        hotelId: hotel.objectId
        duration: +(randomItem gen.duration.split(','))
        price: price
    tours
  faker = ->
    @countries = new countriesList
    @hotels = new hotelsList
    @places = placesList
    @tours = tourFaker
    return

  return new faker
