'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterSelectCtrl', ($scope, $state, Auth, UserStates, Socket) ->
  $scope.characters = []

  # make socket request for character list, attach to scope
  
