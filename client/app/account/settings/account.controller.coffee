'use strict'

angular.module 'miriClientServerApp'
.controller 'AccountCtrl', ($scope, Auth, User) ->
  $scope.errors = {}

  $scope.changeEmail = (form) ->
    $scope.emailSubmitted = true

    if form.$valid
      Auth.changeEmail $scope.user.email
      .then ->
        $scope.emailMessage = 'Email successfully changed.'

      .catch (err) ->
        err = err.data
        $scope.errors = {}

        # Update validity of form fields that match the mongoose errors
        angular.forEach err.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message

  $scope.changePassword = (form) ->
    $scope.pwdSubmitted = true

    if form.$valid
      Auth.changePassword $scope.user.oldPassword, $scope.user.newPassword
      .then ->
        $scope.pwdMessage = 'Password successfully changed.'

      .catch ->
        form.password.$setValidity 'mongoose', false
        $scope.errors.other = 'Incorrect password'
        $scope.pwdMessage = ''
