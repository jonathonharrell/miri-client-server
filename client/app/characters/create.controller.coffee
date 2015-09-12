'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterCreateCtrl', ($scope, $state, Auth, UserStates, Socket) ->
  $scope.step = 0
  $scope.step_titles = ['Race', 'Gender', 'Aesthetic Traits', 'Functional Traits', 'Background', 'Name']
  $scope.races = {}
  $scope.genders = {}
  $scope.aesthetic_traits = {}
  $scope.functional_traits = {}
  $scope.backgrounds = {}

  $scope.character =
    race: null
    gender: null
    aesthetic_traits: null
    functional_traits: null
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

  Socket.send
    command: "newchar"

  Socket.send
    command: "charcreate"

  $scope.$on "ws.charcreateraces", (e, m) ->
    nanobar.go 100 if $scope.character.race?
    _.each m.data, (val) ->
      $scope.races[val.id] = val
    $scope.character.race = _.sample(m.data).id unless $scope.character.race?

  $scope.$on "ws.charcreategenders", (e, m) ->
    _.each m.data, (val) ->
      $scope.genders[val.id] = val
    $scope.character.gender = _.sample(m.data).id unless $scope.character.gender?
    $scope.step += 1 if $scope.step is 0
    nanobar.go 100

  $scope.$on "ws.charcreatestepback", (e, m) ->
    $scope.character.name = null              if $scope.step <= 5
    $scope.character.background = null        if $scope.step <= 4
    $scope.character.functional_traits = null if $scope.step <= 3
    $scope.character.aesthetic_traits = null  if $scope.step <= 2
    $scope.character.gender = null            if $scope.step <= 1

    $scope.step -= 1 if $scope.step > 0
    nanobar.go 100
