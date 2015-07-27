'use strict'

angular.module 'miriClientServerApp'
.controller 'MainCtrl', ($scope, $state, Authentication) ->
  $state.transitionTo 'main.login' unless Authentication.isAuthenticated()
