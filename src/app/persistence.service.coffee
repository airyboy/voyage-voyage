angular.module('voyageVoyage').service 'PersistenceService', ['$resource', '$q', 'ResourceFactory', ($resource, $q, ResourceFactory) ->
  {
    parseResults: (data, headersGetter) ->
      dt = angular.fromJson(data)
      dt.results
    
    resourceName: "tour"

    loadT: ->
      ResourceFactory(@resourceName).query()
    
    TourResource:
      $resource "https://api.parse.com/1/classes/tour/:objectId",
        {objectId: '@objectId' },
        {query:
          {
            isArray: true,
            transformResponse: (data, headersGetter) -> angular.fromJson(data).results }
        'update':
          { method: 'PUT' } }
    
    loadTours: ->
      @TourResource.query()

    loadResource: (resourceName) ->
      ResourceFactory(resourceName).query()

    saveResource: (resourceName, obj) ->
      res = ResourceFactory(resourceName)
      db = new res(obj)
      
      if !obj.objectId
        db.$save()
          .then (response) ->
            obj.objectId = response.objectId
          .catch (error) ->
            console.log error
            alert "Error!"
      else
        db.$update()
          .then (response) ->
            obj.commitChanges()
          .catch (error) ->
            console.log error
            alert "Error!"
            
    removeResource: (resourceName, obj) ->
      res = ResourceFactory(resourceName)
      db = new res(obj)
      db.$remove()
        .catch (error) ->
          console.log error
          alert "Error!"

    saveTour: (tour) ->
      console.log "tour from pers"
      console.log tour
      db = new @TourResource(tour)
      if !tour.objectId
        db.$save()
          .then (response) ->
            tour.objectId = response.objectId
          .catch (error) ->
            console.log error
            alert "Error!"
      else
        db.$update()
          .then (response) ->
            tour.commitChanges()
          .catch (error) ->
            console.log error
            alert "Error!"

    removeTour: (tour) ->
      console.log tour
      db = new @TourResource({ objectId: tour.objectId })
      db.$remove()
        .catch (error) ->
          console.log error
          alert "Error!"

    countriesDefault: ->
      [ {id: 0, name: 'Россия'},
        {id: 1, name: 'США'},
        {id: 2, name: 'Испания'},
        {id: 3, name: 'Турция'},
        {id: 4, name: 'Греция'},
        {id: 5, name: 'Чехия'} ]

    toursDefault: ->
      lorem =  "Lorem ipsum dolor sit amet. Magnam aliquam quaerat voluptatem sequi." +
          " Corporis suscipit laboriosam, nisi ut enim ipsam voluptatem quia. Velit esse, " +
          "quam nihil impedit, quo voluptas nulla. Sint, obcaecati cupiditate non recusandae " +
          "ipsam voluptatem, quia voluptas nulla vero. Officia deserunt mollitia animi, id est " +
          "laborum et harum. Aperiam eaque ipsa, quae ab illo inventore veritatis et dolore magnam " +
          "aliquam. Voluptas sit, amet, consectetur adipisci. Deleniti atque corrupti, quos dolores " +
          "eos, qui dolorem ipsum."
      [
        { id: 0, title: 'Баден Баден', countryId: 5, text: lorem, price: 5000.0 },
        { id: 1, title: 'Маунтин Вью', countryId: 1, text: lorem, price: 40000.0 },
        { id: 2, title: 'Байкал', countryId: 0, text: lorem, price: 8000.0 },
        { id: 3, title: 'Корфу', countryId: 4, text: lorem, price: 8000.0 },
        { id: 4, title: 'Коста Брава', countryId: 2, text: lorem, price: 90500.0 }]
      
    save: (tours) ->
      localStorage.setItem("tours", angular.toJson(tours))
    load: ->
      if localStorage.getItem("tours")
        json = angular.fromJson(localStorage.getItem("tours"))
      else
        @toursDefault()
  }
]
