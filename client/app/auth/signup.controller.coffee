'use strict'

angular.module 'miriClientServerApp'
.controller 'SignupCtrl', ($scope, $rootScope, $state, UserStates, Auth, Socket) ->
  $scope.register = ->
    $scope.submitted = true
    Socket.send
      command: "createuser"
      args: $scope.user

  $scope.$on "ws.createuser", (e, m) ->
    if m.success
      Auth.state = UserStates.InGame.name
      $state.go UserStates[Auth.state].defaultState
    else
      $scope.errors =
        email: []
        password: []

      _.each m.errors, (err) ->
        $scope.errors.email.push    err if err.toLowerCase().indexOf("email")    > -1
        $scope.errors.password.push err if err.toLowerCase().indexOf("password") > -1
      $scope.$apply()
