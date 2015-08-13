'use strict'

angular.module 'miriClientServerApp'
.controller 'SignupCtrl', ($scope, Authentication, Socket) ->
  $scope.register = ->
    data = JSON.stringify
      command: "createuser"
      args: $scope.user
    Socket.send data
