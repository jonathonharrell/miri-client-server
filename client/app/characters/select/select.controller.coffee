'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterSelectCtrl', ($scope, $state, Socket) ->
  $state.go 'main.connect' unless Socket.connected()

  $scope.characters = []

  Socket.send
    command: "list"

  $scope.$on "ws.msg", (e, m) ->
    if m
      characters = [m[0], m[1], m[2]] unless m[3]
    else
      characters = [undefined, undefined, undefined]

    _.each characters, (v, i) ->
      if v is null
        $scope.characters[i] = null
      else
        $scope.characters[i] = v

  $scope.select_character = (id) ->
    console.log id
