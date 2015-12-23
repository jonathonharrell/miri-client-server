'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterDeleteCtrl', ($scope, Socket, $uibModalInstance, character) ->
  $scope.name = character.name.split(' ')[0]
  $scope.characterDeleteName = ''
  $scope.errors = []

  $scope.delete = ->
    $scope.$on 'ws.msg', (e, m) ->
      if m.success
        $uibModalInstance.close true
      else
        $scope.errors = m.errors
    Socket.send
      command: "delete"
      args:
        id: character.id
