'use strict'

angular.module 'miriClientServerApp'
.controller 'ResetPasswordCtrl', ($scope, $state, $http) ->
  resetToken = $state.params.resetToken

  $scope.errors = {}
  $scope.success = false

  $scope.resetPassword = (form) ->
    $scope.submitted = true

    if form.$valid
      $http.put '/api/users/reset/' + resetToken,
        newPassword: $scope.newPassword
      .success ->
        $scope.success = true
      .error (res) ->
        $scope.success = false
        form.newPassword.$setValidity 'mongoose', false
        $scope.errors.newPassword = res.error or "Invalid reset token."
