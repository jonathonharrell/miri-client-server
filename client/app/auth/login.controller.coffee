'use strict'

angular.module 'miriClientServerApp'
.controller 'LoginCtrl', ($scope, $state, Auth, UserStates, Socket) ->
  $scope.user =
    email: ''
    password: ''

  $scope.login = ->
    $scope.submitted = true
    Socket.send
      command: "authenticate"
      args: $scope.user

  $scope.$on "ws.authenticate", (e, m) ->
    if m.success
      Auth.state = UserStates.Authenticated.name
      $state.go UserStates[Auth.state].defaultState
    else
      $scope.errors = []

      _.each m.errors, (err) ->
        $scope.errors.push err
      $scope.$apply()
