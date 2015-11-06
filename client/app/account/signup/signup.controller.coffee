'use strict'

angular.module 'miriClientServerApp'
.controller 'SignupCtrl', ($scope, Auth, $state, Static) ->
  $scope.user = {}
  $scope.errors = {}

  $scope.register = (form) ->
    $scope.submitted = true

    if form.$valid
      # check if the user agrees to the terms
      Static.open 'terms-agree'
      .then (agreed) ->
        return unless agreed

        Auth.createUser
          email: $scope.user.email
          password: $scope.user.password

        .then ->
          # Account created, redirect to home
          $state.go "main.connect"

        .catch (err) ->
          err = err.data
          $scope.errors = {}

          # Update validity of form fields that match the mongoose errors
          angular.forEach err.errors, (error, field) ->
            form[field].$setValidity 'mongoose', false
            $scope.errors[field] = error.message
