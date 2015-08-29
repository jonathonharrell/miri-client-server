'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterSelectCtrl', ($scope, Socket) ->
  $scope.characters = []

  Socket.send
    command: "charlist"

  $scope.$on "ws.charlist", (e, m) ->
    _.each m.data, (v, i) ->
      if Object.keys(v).length is 0
        $scope.characters[i] = null
      else
        $scope.characters[i] = v
