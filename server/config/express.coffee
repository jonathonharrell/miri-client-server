# Express configuration

'use strict'

express        = require "express"
favicon        = require "serve-favicon"
morgan         = require "morgan"
compression    = require "compression"
bodyParser     = require "body-parser"
methodOverride = require "method-override"
cookieParser   = require "cookie-parser"
errorHandler   = require "errorhandler"
path           = require "path"
config         = require "./environment"
passport       = require "passport"
csrf           = require "csurf"
session        = require "express-session"

module.exports = (app) ->
  env = app.get "env"

  app.set "views", config.root + "/server/views"
  app.set "view engine", "jade"
  app.use compression()
  app.use bodyParser.urlencoded({ extended: false })
  app.use bodyParser.json()
  app.use methodOverride()
  app.use cookieParser(config.secrets.session)
  app.use passport.initialize()

  # CSRF protection
  if env isnt "test"
    app.use session({
      cookie:
        path: '/'
        secure: false
        maxAge: 360000 * 24
        httpOnly: true
    })
    app.use csrf()
    app.use (req, res, next) ->
      res.cookie 'XSRF-TOKEN', req.csrfToken()
      next()

  if env is "production"
    app.use favicon(path.join(config.root, "public", "favicon.ico"))
    app.use express.static(path.join(config.root, "public"))
    app.set "appPath", config.root + "/public"
    app.use morgan("dev")

  if env is "development" or env is "test"
    app.use require("connect-livereload")()
    app.use express.static(path.join(config.root, ".tmp"))
    app.use express.static(path.join(config.root, "client"))
    app.set "appPath", "client"
    app.use morgan("dev")
    app.use errorHandler() # Error handler - has to be last
