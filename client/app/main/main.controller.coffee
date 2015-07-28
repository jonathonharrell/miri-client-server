'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, $state, Authentication, Socket) ->
  $state.transitionTo 'main.login' unless Authentication.isAuthenticated()

  Socket.connect()

  $scope.sendCommand = ->
    Socket.send $scope.cmd
    $scope.cmd = ''
