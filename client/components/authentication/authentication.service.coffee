'use strict'

angular.module 'miriClientServerApp'
.service 'Authentication', ->
  class AuthService
    @isAuthenticated: ->
      # !!Session.userId
      true

  return AuthService
