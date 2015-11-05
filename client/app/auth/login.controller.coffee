'use strict'

angular.module 'miriClientServerApp'
.controller 'LoginCtrl', ($scope, Auth, $state) ->
  $scope.user = {}
  $scope.errors = []
  $scope.login = (form) ->
    $scope.submitted = true

    if form.$valid
      Auth.login
        email: $scope.user.email
        password: $scope.user.password

      .then ->
        $state.go "main.character_select"

      .catch (err) ->
        $scope.errors = err
