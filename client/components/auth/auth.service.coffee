'use strict'

angular.module 'miriClientServerApp'
.factory 'Auth', ($http, $cookieStore, $q, ENV) ->
  currentUser = $cookieStore.get 'token'

  # Authenticate user and save token
  login: (user, callback) ->
    $http.post 'http://' + ENV.api + '/login',
      email: user.email
      password: user.password

    .then (res) ->
      $cookieStore.put 'token', res.data.token
      currentUser = res.data.token
      callback?()
      res.data

    , (err) ->
      callback? ["Invalid email or password."]
      $q.reject ["Invalid email or password."]

  # Delete access token and user info
  logout: ->
    $http.get 'http://' + ENV.api + '/logout'
    .then (res) ->
      $cookieStore.remove 'token'
      currentUser = null

  # Create a new user
  createUser: (user, callback) ->
    $http.post 'http://' + ENV.api + '/signup',
      email: user.email
      password: user.password

    .then (res) ->
      $cookieStore.put 'token', res.data.token
      currentUser = res.data.token
      callback?()
      res.data

    , (err) ->
      callback? err.data
      $q.reject err.data

  getCurrentUser: ->
    return currentUser
