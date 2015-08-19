'use strict'

angular.module 'miriClientServerApp'
.controller 'ConnectingCtrl', ($scope, $interval, $state, Auth, UserStates, Socket) ->
  $scope.$on 'ws.unexpected_close', (e, m) ->
    $scope.error_message = m

  # @todo, reconnect attempt a few times before displaying error message

  $scope.connect = ->
    $scope.error_message = false
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

  $scope.connect()
