'use strict'

angular.module 'miriClientServerApp'
.service 'Authentication', ->
  class AuthService
    @isAuthenticated: ->
      # !!Session.userId
      false

  return AuthService
