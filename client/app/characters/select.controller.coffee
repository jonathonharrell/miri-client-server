'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterSelectCtrl', ($scope, Socket) ->
  $scope.characters = []

  Socket.send
    command: "charlist"

  $scope.$on "ws.charlist", (e, m) ->
    console.log m
