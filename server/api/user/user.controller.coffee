"use strict"

User     = require "./user.model"
passport = require "passport"
config   = require "../../config/environment"
jwt      = require "jsonwebtoken"


validationError = (res, statusCode) ->
  statusCode = statusCode or 422
  return (err) -> res.status(statusCode).json err

handleError = (res, statusCode) ->
  statusCode = statusCode or 500
  return (err) -> res.status(statusCode).json err

respondWith = (res, statusCode) ->
  statusCode = statusCode or 200
  return () -> res.status(statusCode).end()

###*
Get list of users
restriction: 'admin'
###
exports.index = (req, res) ->
  User.findAsync {}
    .then (users) ->
      res.json 200, users
    .catch handleError(res)

###*
Creates a new user
###
exports.create = (req, res, next) ->
  newUser = new User req.body
  newUser.provider = "local"
  newUser.role = "user"

  newUser.saveAsync()
    .spread (user) ->
      req.mailer.sendMessage
        template: 'welcome'
        to: user.email
        subject: 'Welcome to Miri Online'
        locals:
          user: user

      token = jwt.sign { _id: user._id }, config.secrets.session, config.jwt_options
      res.json token: token
    .catch validationError(res)

###*
Get a single user
###
exports.show = (req, res, next) ->
  userId = req.params.id

  User.findByIdAsync(userId)
    .then (user) ->
      return res.status(404).end() unless user
      res.json user.profile
    .catch (err) ->
      next err

###*
Deletes a user
restriction: 'admin'
###
exports.destroy = (req, res) ->
  User.findByIdAndRemoveAsync req.params.id
    .then respondWith(res, 204)
    .catch handleError(res)


###*
Change a users password
###
exports.changePassword = (req, res, next) ->
  oldPass = String req.body.oldPassword
  newPass = String req.body.newPassword

  User.findByIdAsync req.user._id, "+salt +password"
    .then (user) ->
      if user.authenticate oldPass
        user.password = newPass
        user.saveAsync()
          .then respondWith res, 204
          .catch validationError res
      else
        res.status(403).end()

###*
 * Forgot Password (set reset password token on user)
###
exports.forgotPassword = (req, res, next) ->
  User.findOneAsync { email: req.body.email }, "+resetPasswordToken +resetPasswordSent"
    .then (user) ->
      return res.status(404).end() unless user

      user.generateResetPasswordToken()
      req.mailer.sendMessage
        template: 'forgot-password'
        to: user.email
        subject: 'Miri Online - Reset Password'
        locals:
          user: user

      user.saveAsync()
        .then respondWith res, 201
        .catch validationError res

###*
 * Reset password based on token
###
exports.resetPassword = (req, res, next) ->
  User.findOneAsync { resetPasswordToken: req.params.resetToken }, "+salt +password +resetPasswordToken +resetPasswordSent"
    .then (user) ->
      return res.status(404).end() unless user

      if user.checkResetToken req.params.resetToken
        user.password = req.body.newPassword
        user.saveAsync()
          .then respondWith res, 204
          .catch validationError res
      else
        res.status(403).json({error: "Reset token expired."})

###*
 * Change a users email
###
exports.changeEmail = (req, res, next) ->
  newEmail = String req.body.email

  User.findByIdAsync req.user._id
    .then (user) ->
      user.email = newEmail
      user.saveAsync()
        .then respondWith res, 204
        .catch validationError res

###*
Get my info
###
exports.me = (req, res, next) ->
  userId = req.user._id
  User.findOneAsync { _id: userId }
    .then (user) ->
      return res.status 401 unless user
      res.json user
    .catch (err) ->
      next err

###*
Authentication callback
###
exports.authCallback = (req, res, next) ->
  res.redirect "/"
