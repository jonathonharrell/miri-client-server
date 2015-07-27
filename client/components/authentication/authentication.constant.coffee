'use strict'

angular.module 'miriClientServerApp'
.constant 'AUTH_EVENTS',
  loginSuccess:     'auth-login-success'
  loginFailed:      'auth-login-failed'
  logoutSuccess:    'auth-logout-success'
  notAuthenticated: 'auth-not-authenticated'
  notAuthorized:    'auth-not-authorized'
