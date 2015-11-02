angular.module('voyageVoyage').service 'ToursFilterService', -> {
  countryFilter: (tour, selectedCountry) ->
    if selectedCountry
      tour.countryId == selectedCountry.objectId
    else
      true

  placeFilter: (tour, selectedPlace) ->
    if selectedPlace
      tour.placeId == selectedPlace.objectId
    else
      true
      
  placesFilteredByCountry: (allPlaces, selectedCountry) ->
    if selectedCountry
      _.where allPlaces, { countryId: selectedCountry.objectId }
    else
      allPlaces
}
