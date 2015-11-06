"use strict"

mongoose    = require("mongoose-bird")()
passport    = require "passport"
config      = require "../config/environment"
jwt         = require "jsonwebtoken"
expressJwt  = require "express-jwt"
compose     = require "composable-middleware"
User        = require "../api/user/user.model"
validateJwt = expressJwt(secret: config.secrets.session)

# Attaches the user object to the request if authenticated
# Otherwise returns 403
isAuthenticated = ->
  compose().use((req, res, next) -> # validate JWT
    # allow access_token to be passed through query parameter as well
    req.headers.authorization = "Bearer " + req.query.access_token if req.query and req.query.hasOwnProperty("access_token")
    validateJwt req, res, next
  ).use (req, res, next) -> # Attach user to request
    User.findByIdAsync req.user._id
      .then (user) ->
        return res.status(401).end() unless user
        req.user = user
        next()
      .catch (err) ->
        next err

# Checks if the user role meets the minimum requirements of the route
hasRole = (roleRequired) ->
  throw new Error "Required role needs to be set" unless roleRequired

  compose().use(isAuthenticated()).use meetsRequirements = (req, res, next) ->
    if config.userRoles.indexOf(req.user.role) >= config.userRoles.indexOf(roleRequired)
      next()
    else
      res.status(403).end()

# Returns a jwt token signed by the app secret
signToken = (id) ->
  jwt.sign { _id: id }, config.secrets.session, config.jwt_options

# Set token cookie directly for oAuth strategies
setTokenCookie = (req, res) ->
  return res.status(404).json { message: "Something went wrong, please try again." } unless req.user

  token = signToken req.user._id, req.user.role
  res.cookie "token", JSON.stringify(token)
  res.redirect "/"

exports.isAuthenticated = isAuthenticated
exports.hasRole = hasRole
exports.signToken = signToken
exports.setTokenCookie = setTokenCookie
