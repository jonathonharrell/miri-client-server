'use strict'

angular.module 'miriClientServerApp'
.controller 'LoginCtrl', ($scope, $state, Auth, UserStates, Socket) ->
  $scope.login = ->
    Socket.send
      command: "authenticate"
      args: $scope.user

  $scope.$on "ws.authenticate", (e, m) ->
    console.log m
    if m.success
      Auth.state = UserStates.InGame.name
      $state.go UserStates[Auth.state].defaultState
