'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterCreateCtrl', ($scope, $state, Auth, UserStates, Socket) ->
  $scope.step = 0
  $scope.step_titles = ['Race', 'Gender', 'Aesthetic Traits', 'Functional Traits', 'Background', 'Name']
  $scope.step_descriptions = [
    "Your choice of race determines your available aesthetic and trait options, as well as potential backgrounds and factions. Some races are more well-received then others in The Miri.",
    "Your choice of gender will affect a few aesthetic options as well as backgrounds, but has no effect on attributes.",
    "This is how you look! These traits will have little to no effect on your play experience - they are used primarily to build a description of your character.",
    "These traits are very important! Their effects range from effecting background choices, to how you are perceived in The Miri, attributes and prowess.",
    "This is your character background. It is your job to fill in the blanks as you roleplay your character in The Miri, and you can do this as you see fit.",
    "Now that we know a little more about your character, all that's left is to give them a name!"
  ]
  $scope.races = {}
  $scope.genders = {}
  $scope.aesthetic_trait_categories  = {}
  $scope.functional_trait_categories = {}
  $scope.backgrounds = {}

  $scope.character =
    race: null
    gender: null
    aesthetic_traits: []
    functional_traits: []
    background: null
    name: null

  $scope.select = (key, val) ->
    $scope.character[key] = val if $scope.character[key]?

  $scope.step_forward = ->
    Socket.send
      command: "charcreate"
      args: $scope.character
    nanobar.go 30

  $scope.step_back = ->
    Socket.send
      command: "charcreatestepback"
    nanobar.go 30

  $scope.selectAestheticTrait = (trait, category) ->
    index = $scope.character.aesthetic_traits.indexOf trait

    if $scope[category] and $scope.aesthetic_trait_categories[category].unique
      $scope.character.aesthetic_traits.splice $scope.character.aesthetic_traits.indexOf($scope[category]), 1
    $scope.character.aesthetic_traits.push trait if index <= -1 and $scope[category] isnt trait
    $scope.character.aesthetic_traits.splice index, 1 if $scope[category] is trait and !$scope.aesthetic_trait_categories[category].unique
    $scope[category] = trait

  Socket.send
    command: "newchar"

  Socket.send
    command: "charcreate"

  $scope.$on "ws.charcreateraces", (e, m) ->
    nanobar.go 100 if $scope.character.race?
    _.each m.data, (val) ->
      $scope.races[val.id] = val
    $scope.character.race = $scope.races['HUMAN'].id unless $scope.character.race?

  $scope.$on "ws.charcreategenders", (e, m) ->
    $scope.genders = {}
    _.each m.data, (val) ->
      $scope.genders[val.id] = val
    $scope.character.gender = _.sample(m.data).id unless $scope.character.gender?

  $scope.$on "ws.charcreateaesthetic", (e, m) ->
    $scope.aesthetic_trait_categories = {}
    _.each m.data, (val) ->
      $scope.aesthetic_trait_categories[val.id] = val

  $scope.$on "ws.charcreatestepup", (e, m) ->
    unless m.success
      $scope.errors = m.errors
    else
      $scope.errors = []
      $scope.step += 1
    nanobar.go 100

  $scope.$on "ws.charcreatestepback", (e, m) ->
    $scope.character.name = null              if $scope.step <= 5
    $scope.character.background = null        if $scope.step <= 4
    $scope.character.functional_traits = null if $scope.step <= 3
    $scope.character.aesthetic_traits = null  if $scope.step <= 2
    $scope.character.gender = null            if $scope.step <= 1

    $scope.errors = []
    $scope.step -= 1 if $scope.step > 0
    nanobar.go 100
