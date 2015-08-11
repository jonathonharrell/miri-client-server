'use strict'

angular.module 'miriClientServerApp'
.controller 'LoginCtrl', ($scope, Authentication, Socket) ->
  $scope.login = ->
    data = JSON.stringify
      command: "Authenticate"
      args: $scope.user
    Socket.send data
