'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, $rootScope, Socket, Auth) ->
  $scope.msgs = []
  $scope.admin_form =
    args: undefined
    command: ""

  $scope.$on "ws.general_message", (e) ->
    $scope.msgs.push msg
    $scope.$apply()

  $scope.sendDialogCommand = ->
    Socket.send $scope.dialog
    $scope.dialog.args.input = ''

  $scope.sendCommand = ->
    Socket.send
      command: $scope.admin_form.command
      args: if $scope.admin_form.args then JSON.parse($scope.admin_form.args) else undefined
    $scope.admin_form.args = undefined

  $scope.auth = Auth

  $scope.logout = ->
    Auth.logout()
