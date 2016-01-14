'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, $rootScope, $state, Socket, Auth) ->
  $state.go 'main.connect' unless Socket.connected() or not Auth.isLoggedIn()

  $scope.MOVEMENT = ['north','south','southeast','southwest','west','east','northwest','northeast']
  $scope.msgs = []
  $scope.status_effects = []
  $scope.time_weather = {}
  $scope.state = []
  $scope.cmd = ''
  previous_commands = []
  selected_command_index = 0
  $scope.admin_form =
    args: undefined
    command: ""

  $scope.$on "ws.msg", (e, r) ->
    $scope.location       = r.room           if r.room
    $scope.state          = r.state          if r.state isnt "" and r.state isnt null
    $scope.directions     = r.directions     if r.directions
    $scope.status_effects = r.status_effects if r.status_effects
    $scope.time_weather   = r.time_weather   if r.time_weather
    $scope.targets        = r.targets        if r.targets
    console.log $scope.targets

    $('.new-message').removeClass 'new-message'
    _.each r.messages, handleMessage

    $scope.$apply()

  $scope.targeted = (id) ->
    _.contains $scope.targets, id

  $scope.send = (cmd, args) ->
    Socket.send
      command: cmd
      args: input: args

  $scope.sendCommand = ->
    Socket.send
      command: 'admin_' + $scope.admin_form.command
      args: if $scope.admin_form.args then JSON.parse($scope.admin_form.args) else undefined
    $scope.admin_form.args = undefined

  $scope.sendCmd = ->
    cmd = $scope.cmd.split(" ")[0]
    rest = $scope.cmd.replace(cmd + " ", "") || ""
    Socket.send command: cmd, args: input: rest
    $scope.cmd = ''

  $scope.auth = Auth

  $scope.logout = ->
    Auth.logout ->
      $state.go "main.login"

  $scope.moving = ->
    _.contains $scope.state, "moving"

  handleMessage = (msg) ->
    el = $('<div class="row new-message"><div class="col-sm-12">' + msg + '</div></div>')
    el.hide().fadeIn(500)
    $('.message-container').append(el)
    $('.message-container').scrollTop $('.message-container')[0].scrollHeight
