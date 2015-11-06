# Nodemailer configuration

'use strict'

mailer = require "../lib/email.service"

module.exports = (app) ->
  # attach mailer to app request object
  app.use (req, res, next) ->
    req.mailer = mailer app.get("env")
    next()
