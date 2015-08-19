'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, Socket) ->
  $scope.msgs = []

  $scope.$on "ws.general_message", (e) ->
    $scope.msgs.push msg
    $scope.$apply()

  $scope.sendCommand = ->
    Socket.send $scope.dialog
    $scope.dialog.args.input = ''
