'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, $rootScope, $state, Socket, Auth) ->
  $state.go 'main.connect' unless Socket.connected() or not Auth.isLoggedIn()

  $scope.MOVEMENT = ['north','south','southeast','southwest','west','east','northwest','northeast']
  $scope.msgs = []
  $scope.admin_form =
    args: undefined
    command: ""

  $scope.$on "ws.msg", (e, r) ->
    $scope.location = r.room if r.room
    _.each r.messages, (msg) ->
      $('.message-container').append '<div class="row"><div class="col-sm-12">' + msg + '</div></div>'
      $('.message-container').scrollTop $('.message-container')[0].scrollHeight
    $scope.directions = r.directions if r.directions
    $scope.$apply()

  $scope.send = (cmd, args) ->
    Socket.send
      command: cmd
      args: args

  $scope.sendCommand = ->
    Socket.send
      command: 'admin_' + $scope.admin_form.command
      args: if $scope.admin_form.args then JSON.parse($scope.admin_form.args) else undefined
    $scope.admin_form.args = undefined

  $scope.auth = Auth

  $scope.logout = ->
    Auth.logout ->
      $state.go "main.login"
