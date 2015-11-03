angular.module('voyageVoyage').service 'ToursFilterService', -> {
  countryFilter: (tour, selectedCountry) ->
    if selectedCountry then tour.countryId == selectedCountry.objectId else true

  placeFilter: (tour, selectedPlace) ->
    if selectedPlace then tour.placeId == selectedPlace.objectId else true
      
  placesFilteredByCountry: (allPlaces, selectedCountry) ->
    if selectedCountry then _.where allPlaces, { countryId: selectedCountry.objectId } else allPlaces
}
