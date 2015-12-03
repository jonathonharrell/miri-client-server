'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterDeleteCtrl', ($scope, Socket, $modalInstance, character) ->
  $scope.name = character.name.split(' ')[0]
  $scope.characterDeleteName = ''

  $scope.delete = ->
    Socket.send
      command: "delete"
      args:
        id: character.id
    $modalInstance.close true
