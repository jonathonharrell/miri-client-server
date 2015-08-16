'use strict'

angular.module 'miriClientServerApp'
.controller 'LoginCtrl', ($scope, Auth, Socket) ->
  $scope.login = ->
    data = JSON.stringify
      command: "authenticate"
      args: $scope.user
    Socket.send data
