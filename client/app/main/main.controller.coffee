'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, $state, Auth, UserStates, Socket) ->
  $scope.msgs = []

  $scope.loading_message = "Connecting..."
  Socket.connect (m) ->
    $scope.loading_message = m
    Auth.state = UserStates.NotAuthenticated.name
    $state.go UserStates[Auth.state].defaultState

  $scope.$on "ws.general_message", (e) ->
    $scope.msgs.push msg
    $scope.$apply()

  $scope.sendCommand = ->
    Socket.send $scope.dialog
    $scope.dialog.args.input = ''
