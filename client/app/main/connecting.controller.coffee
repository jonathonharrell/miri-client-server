'use strict'

angular.module 'miriClientServerApp'
.controller 'ConnectingCtrl', ($scope, $interval, $timeout, $state, Auth, Socket) ->
  connect_failure = 0
  $scope.messages = []

  $scope.$on 'ws.unexpected_close', (e, m) ->
    connect_failure += 1
    $scope.messages.push 'Connection Failed, trying again.'

    if connect_failure >= 3
      connect_failure = 0
      $scope.messages = []
      $scope.error_message = m
    else
      $timeout $scope.connect, 1000

  $scope.loading_message = "Connecting"
  $scope.loading_postfix = "..."

  $interval ->
    $scope.loading_postfix += "." if $scope.loading_postfix.length <= 3
    $scope.loading_postfix  = "." if $scope.loading_postfix.length > 3
  , 500

  $scope.connect = ->
    $scope.error_message = false

    Socket.connect (m) ->
      $scope.loading_message = m
      Auth.state = UserStates.NotAuthenticated.name
      $state.go UserStates[Auth.state].defaultState

  $scope.connect()
