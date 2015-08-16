'use strict'

angular.module 'miriClientServerApp'
.controller 'SignupCtrl', ($scope, $rootScope, $state, UserStates, Auth, Socket) ->
  $scope.$on "ws.createuser", (e, m) ->
    console.log m
    if m.success
      Auth.state = UserStates.InGame.name
      $state.go UserStates[Auth.state].defaultState

  $scope.register = ->
    Socket.send
      command: "createuser"
      args: $scope.user
