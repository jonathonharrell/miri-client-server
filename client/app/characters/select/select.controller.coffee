'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterSelectCtrl', ($scope) ->
  $scope.characters = []

  Socket.send
    command: "charlist"

  $scope.$on "ws.charlist", (e, m) ->
    _.each m.data, (v, i) ->
      if v is null
        $scope.characters[i] = null
      else
        $scope.characters[i] = v

  $scope.select_character = (id) ->
    console.log id
