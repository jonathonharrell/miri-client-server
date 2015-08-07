'use strict'

angular.module 'miriClientServerApp'
.controller 'LoginCtrl', ($scope, Authentication, Socket) ->
  $scope.login = ->
    data = JSON.stringify
      command: "authenticate"
      args: $scope.user
    Socket.send data
