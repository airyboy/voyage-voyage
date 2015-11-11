angular.module('voyageVoyage').service 'ToursFilterService', (_) -> {
  countryFilter: (tour, selectedCountry) ->
    if selectedCountry then tour.countryId == selectedCountry.objectId else true

  placeFilter: (tour, selectedPlace) ->
    if selectedPlace then tour.placeId == selectedPlace.objectId else true

  starsFilter: (tour, hotels, selectedStars) ->
    if selectedStars
      hotel = _.find hotels, (hotel) -> hotel.objectId == tour.hotelId
      hotel.stars == selectedStars.val
    else
      true
}
