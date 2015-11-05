'use strict'

angular.module 'miriClientServerApp'
.factory 'Auth', ($http, $cookieStore, $q, ENV) ->
  currentUser = $cookieStore.get 'token'
  api = window.location.protocol + '//' + ENV.api

  # Authenticate user and save token
  login: (user, callback) ->
    $http.post api + '/login',
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
  logout: (callback) ->
    $http.get api + '/logout'
    .then (res) ->
      $cookieStore.remove 'token'
      currentUser = null
      callback?()

  # Create a new user
  createUser: (user, callback) ->
    $http.post api + '/signup',
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
