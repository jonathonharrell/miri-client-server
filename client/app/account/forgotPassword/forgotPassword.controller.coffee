'use strict'

angular.module 'miriClientServerApp'
.controller 'ForgotPasswordCtrl', ($scope, $http) ->

  $scope.errors = {}
  $scope.email = ''
  $scope.message = ''
  $scope.success = false

  $scope.forgotPassword = (form) ->
    $scope.submitted = true

    if form.$valid
      $http.post '/api/users/forgot',
        email: $scope.email
      .success ->
        $scope.message = 'Sent. Please check your email for further instructions.'
        $scope.success = true
      .error ->
        form.email.$setValidity 'mongoose', false
        $scope.message = ''
        $scope.errors.email = 'Account not found.'
