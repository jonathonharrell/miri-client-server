'use strict'

angular.module 'miriClientServerApp'
.service 'Authentication', ->
  class AuthService
    @isAuthenticated: false

  return AuthService
