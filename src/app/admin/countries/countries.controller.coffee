#angular.module('voyageVoyage').controller 'CountriesController', ($scope, PersistenceService, $resource) ->
angular.module('voyageVoyage').controller 'CountriesController', ['$scope', '$resource', 'PersistenceService',
  ($scope, $resource, PersistenceService) ->
    #=require country.coffee
    #=require countries.states.coffee

    parseResults = (data, headersGetter) ->
      dt = angular.fromJson(data)
      dt.results

    CountryDb = $resource 'https://api.parse.com/1/classes/country/:objectId',
      {objectId: '@objectId' },
      {query: { isArray: true, transformResponse: parseResults }, 'update': { method: 'PUT' } }
    
    do ->
      #json = PersistenceService.countriesDefault()
      CountryDb.query().$promise.then (data) ->
        $scope.countries = ((new Country).fromJSON(e) for e in data)
        $scope.state = new BrowseState

    $scope.add = ->
      db = new CountryDb({ name: $scope.state.country.name })
      db.$save().then (response) ->
        $scope.state.country.objectId = response.objectId
        $scope.countries.push($scope.state.country)
        $scope.setState 'browse'

    $scope.update = ->
      copy = $scope.state.country
      db = new CountryDb(copy)
      db.$update().then (response) ->
        $scope.state.country.commitChanges()
        $scope.setState 'browse'
      
      
    $scope.cancelEdit = ->
      $scope.state.country.rejectChanges()
      $scope.setState 'browse'

    $scope.remove = (idx) ->
      if confirm("Удалить?")
        country = $scope.countries[idx]
        db = new CountryDb({ objectId: country.objectId })
        db.$remove().then((response) ->
          $scope.countries.splice(idx))
        .catch (error) ->
          console.log error
      
    $scope.setState = (state, idx, country) ->
      $scope.state = switch state
        when 'browse' then new BrowseState
        when 'add' then new NewState
        when 'edit' then new EditState(country, idx)
   ]
