'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterSelectCtrl', ($scope, $state, Socket, $modal) ->
  $state.go 'main.connect' unless Socket.connected()

  $scope.characters = []

  $scope.deleteCharacter = (c) ->
    modalInstance = $modal.open
      templateUrl: 'app/characters/delete/delete.html'
      controller: 'CharacterDeleteCtrl'
      resolve:
        character: c

    modalInstance.result.then (list) ->
      getList() if list

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

  $scope.selectCharacter = (id) ->
    console.log id

  getList = ->
    Socket.send
      command: "list"
  getList()
