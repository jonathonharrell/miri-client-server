'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterCreateCtrl', ($scope, $state, Auth, UserStates, Socket) ->
  $scope.step = 0
  $scope.races = []

  Socket.send
    command: "charcreate"

  $scope.$on "ws.charcreate", (e, m) ->
    $scope.races = m.data
