'use strict'

passport      = require("passport")
LocalStrategy = require("passport-local").Strategy

localAuthenticate = (User, email, password, done) ->
  User.findOneAsync
    email: email.toLowerCase()
  , "+salt +password +failedLoginAttempts +lastLogin"
  .then (user) ->
    return done null, false, { message: "Invalid credentials." } unless user

    user.authenticate password, (authError, authenticated) ->
      return done authError if authError

      failedAttempts = if authenticated and not user.locked then 0 else user.failedLoginAttempts + 1

      # this might be somewhat ineffecient, would rather be doing .save(callback)
      user.update { failedLoginAttempts: failedAttempts, lastLogin: new Date() }, (err) ->
        return done null, false, { message: "Too many login attempts. Account temporarily locked." } if user.locked
        return done null, false, { message: "Invalid credentials" } unless authenticated

        done null, user
  .catch (err) ->
    done err

exports.setup = (User, config) ->
  passport.use new LocalStrategy(
    usernameField: "email"
    passwordField: "password"
  , (email, password, done) ->
    localAuthenticate User, email, password, done
  )
