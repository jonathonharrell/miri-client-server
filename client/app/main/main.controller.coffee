'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, $state, Authentication, Socket) ->
  $state.transitionTo 'main.login' unless Authentication.isAuthenticated()

  $scope.msgs = []

  Socket.connect()
  Socket.attachOnMessage (msg) ->
    $scope.msgs.push msg
    $scope.$apply()

  $scope.sendCommand = ->
    Socket.send JSON.stringify $scope.dialog
    $scope.dialog.args.input = ''
