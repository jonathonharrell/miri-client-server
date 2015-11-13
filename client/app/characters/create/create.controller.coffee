'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterCreateCtrl', ($scope, $state, Auth, Socket) ->
  $state.go 'main.connect' unless Socket.connected()

  $scope.step = 0
  $scope.step_titles = ['Race', 'Gender', 'Appearance', 'Traits', 'Background', 'Name']
  $scope.step_options = ['races', 'genders', 'aesthetic_traits', 'functional_traits', 'backgrounds']
  $scope.step_descriptions = [
    "Your choice of race determines your available aesthetic and trait options, as well as potential backgrounds and factions. Some races are more well-received then others in The Miri.",
    "Your choice of gender will affect a few aesthetic options as well as backgrounds, but has no effect on attributes.",
    "This is how you look! These traits will have little to no effect on your play experience - they are used primarily to build a description of your character.",
    "These traits are very important! Their effects range from effecting background choices, to how you are perceived in The Miri, attributes and prowess.",
    "This is your overarching character background - it determines your starting locale and resources, and provides a basis with which to role-play. Fill in the blanks as you see fit!",
    "Now that we know a little more about your character, all that's left is to give them a name!"
  ]

  $scope.races = {}
  $scope.genders = {}
  $scope.aesthetic_trait_categories  = {}
  $scope.functional_trait_categories = {}
  $scope.functional_traits = {}
  $scope.point_deficit = 0
  $scope.backgrounds = {}
  $scope.description = {}
  $scope.trait_tracker = {}

  $scope.character =
    race: null
    gender: null
    aesthetic_traits: {}
    functional_traits: {}
    background: null
    name: null

  $scope.select = (key, val) ->
    $scope.character[key] = val if $scope.character[key]?

  $scope.step_forward = ->
    $scope.step += 1
    # @todo also validate here
    getGenders() if $scope.step is 1
    getAestheticTraits() if $scope.step is 2
    getFunctionalTraits() if $scope.step is 3
    getBackgrounds() if $scope.step is 4

  $scope.step_back = ->
    $scope.character.name = null              if $scope.step <= 5
    $scope.character.background = null        if $scope.step <= 4
    $scope.character.functional_traits = []   if $scope.step <= 3
    $scope.character.aesthetic_traits = []    if $scope.step <= 2
    $scope.trait_tracker = {}                 if $scope.step <= 2
    $scope.description = {}                   if $scope.step <= 2
    $scope.character.gender = null            if $scope.step <= 1

    $scope.errors = []
    $scope.step -= 1 if $scope.step > 0

  $scope.selectAestheticTrait = (trait, category) ->
    $scope.character.aesthetic_traits[category] = [] unless $scope.character.aesthetic_traits[category]?
    index = $scope.character.aesthetic_traits[category].indexOf trait.id
    exists = index > -1
    unique = $scope.aesthetic_trait_categories[category].unique

    $scope.description[category] = [] if unique and !exists

    unless exists
      $scope.character.aesthetic_traits[category] = [] if unique
      $scope.character.aesthetic_traits[category].push trait.id
      $scope.description[category] = [] unless $scope.description[category]
      $scope.description[category].push trait.description
    else
      return if unique
      $scope.character.aesthetic_traits[category].splice index, 1
      $scope.description[category].splice $scope.description[category].indexOf(trait.description), 1

  $scope.selectFunctionalTrait = (trait, category) ->
    $scope.character.functional_traits[category] = [] unless $scope.character.functional_traits[category]?
    index = $scope.character.functional_traits[category].indexOf trait.id
    exists = index > -1
    unique = $scope.functional_trait_categories[category].unique

    if unique and not exists and $scope.character.functional_traits[category].length > 0
      point_modifier = $scope.functional_trait_categories[category].traits[$scope.character.functional_traits[category][0]].points
      $scope.point_deficit -= Number(point_modifier)

    unless exists
      $scope.character.functional_traits[category] = [] if unique
      $scope.character.functional_traits[category].push trait.id
      $scope.point_deficit += Number(trait.points)
    else
      return if unique
      $scope.point_deficit -= Number($scope.trait_tracker[category].points)
      $scope.character.functional_traits[category].splice index, 1

  $scope.selectBackground = (bg) ->
    $scope.character.background = bg

  $scope.$on 'ws.msg', (e, m) ->
    $scope.handler(e, m)

  get = (o) ->
    Socket.send
      command: "options"
      args:
        get: o

  # @todo filter options
  getRaces = ->
    $scope.handler = (event, result) ->
      $scope.races[result["HUMAN"].id] = result['HUMAN'] # set human first
      delete result["HUMAN"]
      _.each result, (val) ->
        $scope.races[val.id] = val
      $scope.character.race = $scope.races['HUMAN'].id unless $scope.character.race?

    get "races"

  getGenders = ->
    $scope.handler = (event, result) ->
      $scope.genders = result
      $scope.character.gender = _.sample(result).id unless $scope.character.gender?

    get "genders"

  getAestheticTraits = ->
    $scope.handler = (event, result) ->
      $scope.aesthetic_trait_categories = result
    get "aesthetic_traits"

  getFunctionalTraits = ->
    $scope.handler = (event, result) ->
      $scope.functional_trait_categories = result
      _.each result, (val) ->
        _.each val.traits, (t) ->
          $scope.character.functional_traits[val.id] = [] unless $scope.character.functional_traits[val.id]?
          $scope.character.functional_traits[val.id].push t.id if t.required
    get "functional_traits"

  getBackgrounds = ->
    $scope.handler = (event, result) ->
      $scope.backgrounds = result
      $scope.character.background = _.sample(result).id unless $scope.character.background?
    get "backgrounds"

  getRaces()
