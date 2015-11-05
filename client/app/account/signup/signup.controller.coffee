'use strict'

angular.module 'miriClientServerApp'
.controller 'SignupCtrl', ($scope, Auth, $state) ->
  $scope.user =
    email: ''
    password: ''

  $scope.user = {}
  $scope.errors = []
  $scope.register = (form) ->
    $scope.submitted = true

    if form.$valid
      Auth.createUser $scope.user
      .then ->
        $state.go "main.character_select"

      .catch (err) ->
        $scope.errors =
          email: []
          password: []

        _.each err, (e) ->
          $scope.errors.email.push    e if e.toLowerCase().indexOf("email")    > -1
          $scope.errors.password.push e if e.toLowerCase().indexOf("password") > -1
