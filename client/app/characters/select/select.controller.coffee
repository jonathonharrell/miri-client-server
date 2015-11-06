'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterSelectCtrl', ($scope, Socket) ->
  $scope.characters = []

  Socket.send
    command: "list"

  $scope.$on "ws.charlist", (e, m) ->
    _.each m.data, (v, i) ->
      if v is null
        $scope.characters[i] = null
      else
        $scope.characters[i] = v

  $scope.select_character = (id) ->
    console.log id
