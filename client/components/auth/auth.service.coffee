'use strict'

angular.module 'miriClientServerApp'
.factory 'Auth', ($http, User, $cookieStore, $q, Socket) ->
  currentUser = if $cookieStore.get 'token' then User.get() else {}

  # Authenticate user and save token
  login: (user, callback) ->
    $http.post '/auth/local',
      email: user.email
      password: user.password

    .then (res) ->
      $cookieStore.put 'token', res.data.token
      currentUser = User.get()
      callback?()
      res.data

    , (err) ->
      callback? err.data
      $q.reject err.data

  # Delete access token and user info
  logout: ->
    Socket.disconnect()
    $cookieStore.remove 'token'
    currentUser = {}
    return

  # Create a new user
  createUser: (user, callback) ->
    User.save user,
      (data) ->
        $cookieStore.put 'token', data.token
        currentUser = User.get()
        callback? null, user

      , (err) =>
        @logout()
        callback? err

    .$promise

  # Change password
  changePassword: (oldPassword, newPassword, callback) ->
    User.changePassword
      id: currentUser._id
    ,
      oldPassword: oldPassword
      newPassword: newPassword

    , (user) ->
      callback? null, user

    , (err) ->
      callback? err

    .$promise

  # Change email
  changeEmail: (email, callback) ->
    User.changeEmail
      id: currentUser._id
    ,
      email: email

    , () ->
      currentUser.email = email
      callback? null, user

    , (err) ->
      callback? err

    .$promise

  # Gets all available info on authenticated user
  getCurrentUser: (callback) ->
    return currentUser if arguments.length is 0

    value = if (currentUser.hasOwnProperty("$promise")) then currentUser.$promise else currentUser
    $q.when value

    .then (user) ->
      callback? user
      user

    , ->
      callback? {}
      {}

  # Waits for currentUser to resolve before checking if user is logged in
  isLoggedIn: (callback) ->
    return currentUser.hasOwnProperty "role" if arguments.length is 0

    @getCurrentUser null

    .then (user) ->
      is_ = user.hasOwnProperty "role"
      callback? is_
      is_

  # Check if a user is an admin
  isAdmin: (callback) ->
    return currentUser.role is "admin" if arguments.length is 0

    @getCurrentUser null

    .then (user) ->
      is_ = user.role is "admin"
      callback? is_
      is_

  # Get auth token
  getToken: ->
    $cookieStore.get 'token'
