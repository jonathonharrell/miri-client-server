'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, $rootScope, $state, Socket, Auth) ->
  $state.go 'main.connect' unless Socket.connected() or not Auth.isLoggedIn()

  $scope.MOVEMENT = ['north','south','southeast','southwest','west','east','northwest','northeast']
  $scope.msgs = []
  $scope.state = 'default'
  $scope.admin_form =
    args: undefined
    command: ""

  $scope.$on "ws.msg", (e, r) ->
    $scope.location   = r.room       if r.room
    $scope.state      = r.state      if r.state isnt ""
    $scope.directions = r.directions if r.directions

    $('.new-message').removeClass 'new-message'
    _.each r.messages, handleMessage

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

  $scope.sendDialogCommand = ->
    Socket.send $scope.dialog
    $scope.dialog.args.input = ''

  $scope.auth = Auth

  $scope.logout = ->
    Auth.logout ->
      $state.go "main.login"

  handleMessage = (msg) ->
    el = $('<div class="row new-message"><div class="col-sm-12">' + msg + '</div></div>')
    el.hide().fadeIn(500)
    $('.message-container').append(el)
    $('.message-container').scrollTop $('.message-container')[0].scrollHeight
