angular.module("voyageVoyage").factory "NewTourNotification", ($rootScope, TourRepository) ->
  self = this

  self.init = ->
    func = ->
      nextTimeout = Math.floor(Math.random() * 10000)
      setTimeout(
        (() ->
          if TourRepository.tours.length > 0
            total = TourRepository.tours.length
            randomIndex = Math.floor(Math.random() * total)
            randomTour = TourRepository.tours[randomIndex]
            tour =
              tour:
                title: randomTour.title
                url: "/tour/#{randomTour.objectId}"
                price: randomTour.price
            $rootScope.$broadcast('tour.new', tour)
            ),
        nextTimeout)
    setInterval(func, 10000)

  self
