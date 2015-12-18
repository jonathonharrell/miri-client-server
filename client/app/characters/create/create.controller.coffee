'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterCreateCtrl', ($scope, $state, Auth, Socket, $filter) ->
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
  $scope.point_deficit = 0
  $scope.errors = []
  $scope.backgrounds = {}
  $scope.description = {}
  $scope.showLoader = false
  for_validation =
    aesthetic_traits:  []
    functional_traits: []

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
    getGenders() if $scope.step is 1
    getAestheticTraits() if $scope.step is 2
    getFunctionalTraits() if $scope.step is 3 and validate('aesthetic_traits')
    getBackgrounds() if $scope.step is 4 and validate('functional_traits')
    $scope.errors.push 'You must select a background.' if $scope.step is 5 and not $scope.character.background?

  $scope.create_character = ->
    $scope.errors = []
    if validateName($scope.character.name)
      Socket.send
        command: "create"
        args: $scope.character
      $scope.handler = (event, result) ->
        $scope.errors = result.errors unless result.success
        $state.go 'main.characterSelect' if result.success

  $scope.step_back = ->
    $scope.character.name = null              if $scope.step <= 5
    $scope.character.background = null        if $scope.step <= 4
    $scope.character.functional_traits = {}   if $scope.step <= 3
    $scope.character.aesthetic_traits = {}    if $scope.step <= 2
    $scope.description = {}                   if $scope.step <= 2
    $scope.character.gender = null            if $scope.step <= 1

    $('input.aesthetic_trait').attr 'checked', false  if $scope.step <= 2
    $('input.functional_trait').attr 'checked', false if $scope.step <= 3
    $scope.point_deficit = 0                          if $scope.step <= 3

    $scope.errors = []
    $scope.step -= 1 if $scope.step > 0

  $scope.selectAestheticTrait = (trait, category) ->
    $scope.character.aesthetic_traits[category] = [] unless $scope.character.aesthetic_traits[category]?
    index = $scope.character.aesthetic_traits[category].indexOf trait.id
    exists = index > -1
    unique = $scope.aesthetic_trait_categories[category].unique
    required = $scope.aesthetic_trait_categories[category].min > 0

    $scope.description[category] = [] if unique and !exists

    unless exists
      $scope.character.aesthetic_traits[category] = [] if unique
      $scope.character.aesthetic_traits[category].push trait.id
      $scope.description[category] = [] unless $scope.description[category]
      $scope.description[category].push trait.description
    else
      return if unique and required
      $('input[name=' + category + ']').attr 'checked', false
      $scope.character.aesthetic_traits[category].splice index, 1
      $scope.description[category].splice $scope.description[category].indexOf(trait.description), 1

  $scope.selectFunctionalTrait = (trait, category) ->
    $scope.character.functional_traits[category] = [] unless $scope.character.functional_traits[category]?
    index = $scope.character.functional_traits[category].indexOf trait.id
    exists = index > -1
    unique = $scope.functional_trait_categories[category].unique
    required = $scope.functional_trait_categories[category].min > 0

    if unique and not exists and $scope.character.functional_traits[category].length > 0
      point_modifier = $scope.functional_trait_categories[category].traits[$scope.character.functional_traits[category][0]].points
      $scope.point_deficit -= Number(point_modifier)

    unless exists
      $scope.character.functional_traits[category] = [] if unique
      $scope.character.functional_traits[category].push trait.id
      $scope.point_deficit += Number(trait.points)
    else
      return if unique and required
      $('input[name=' + category + ']').attr 'checked', false
      $scope.point_deficit -= Number(trait.points)
      $scope.character.functional_traits[category].splice index, 1

  validate = (type) ->
    $scope.errors = []
    categories =
      aesthetic_traits: 'aesthetic_trait_categories'
      functional_traits: 'functional_trait_categories'
    valid = true

    if $scope.point_deficit < 0
      valid = false
      $scope.errors.push 'You must have 0 or more points to continue.'

    _.each $scope[categories[type]], (c) ->
      exists = $scope.character[type][c.id]?
      if c.min > 0 and !exists
        valid = false
        $scope.errors.push c.name + ' requires at least ' + c.min + ' selection.'
      if exists
        if c.min > 0 and $scope.character[type][c.id].length < c.min
          valid = false
          $scope.errors.push c.name + ' requires at least ' + c.min + ' selections.'

    $scope.step -= 1 unless valid
    valid

  validateName = (name) ->
    unless name and name.length >= 5
      $scope.errors.push 'Name is not long enough.'
      return false

    num_spaces = name.split(" ").length - 1
    if num_spaces < 1
      $scope.errors.push 'You must have a first name and a surname / family name (last name).'
      return false
    if num_spaces > 1
      $scope.errors.push 'You may only have a first name and a last name.'
      return false

    unless /^['a-zA-Z-\s]+$/.test(name)
      $scope.errors.push 'Invalid characters in name'
      return false

    name = name.split(" ")
    if name[0].length < 2
      $scope.errors.push 'First name must be two or more characters.'
      return false
    if name[1].length < 2
      $scope.errors.push 'Last name must be two or more characters.'
      return false

    true

  $scope.$on 'ws.msg', (e, m) ->
    $scope.handler(e, m)
    $scope.showLoader = false

  get = (o) ->
    $scope.showLoader = true
    Socket.send
      command: "options"
      args:
        get: o

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
      $scope.genders = filtered_genders = $filter('traits')(result, $scope.character)
      $scope.character.gender = _.sample(filtered_genders).id unless $scope.character.gender?

    get "genders"

  getAestheticTraits = ->
    $scope.handler = (event, result) ->
      result = $filter('traits')(result, $scope.character)
      $scope.aesthetic_trait_categories = result
    get "aesthetic_traits"

  getFunctionalTraits = ->
    $scope.point_deficit = 0
    $scope.handler = (event, result) ->
      result = $filter('traits')(result, $scope.character)
      $scope.functional_trait_categories = result
      _.each result, (val) ->
        traits = $filter('traits')(val.traits, $scope.character)
        _.each traits, (t) ->
          $scope.character.functional_traits[val.id] = [] unless $scope.character.functional_traits[val.id]?
          $scope.character.functional_traits[val.id].push t.id if t.required
    get "functional_traits"

  getBackgrounds = ->
    $scope.handler = (event, result) ->
      $scope.backgrounds = filtered_backgrounds = $filter('backgrounds')(result, $scope.character)
      $scope.character.background = _.sample(filtered_backgrounds).id unless $scope.character.background?
    get "backgrounds"

  getRaces()
