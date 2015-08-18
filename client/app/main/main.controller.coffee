'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, $interval, $state, Auth, UserStates, Socket) ->
  $scope.msgs = []

  # handle the connecting string thingy, @todo this should probably be in its own controller so as to avoid leaving the interval running
  $scope.loading_message = "Connecting"
  $scope.loading_postfix = "..."

  $interval ->
    $scope.loading_postfix += "." if $scope.loading_postfix.length <= 3
    $scope.loading_postfix  = "." if $scope.loading_postfix.length > 3
  , 500

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
