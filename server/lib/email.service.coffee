# Mailer extra methods (includes dev tools for "letter opener")

'use strict'

mailer = require "nodemailer"
path   = require "path"
jade   = require "jade"
fs     = require "fs"
open   = require "open"
mkdirp = require "mkdirp"
config = require "../config/environment"

sgOptions =
  auth:
    api_user: config.sendgrid.user or ''
    api_key:  config.sendgrid.key  or ''

stubTransport = require "nodemailer-stub-transport"
sgTransport   = require "nodemailer-mailgun-transport"
htmlToText    = require("nodemailer-html-to-text").htmlToText

module.exports = (env) ->
  transport = undefined
  transport = if env is "production" then mailer.createTransport sgTransport(sgOptions)
  else mailer.createTransport stubTransport()
  transport.use htmlToText()

  templateDir = path.join __dirname, "views", "email"

  transport.sendMessage = (options, callback) ->
    # bootstrap baseUrl to local variables
    options.locals = options.locals or {}
    options.locals.baseUrl = config.baseUrl

    try
      file = path.join templateDir, options.template + ".jade"
      render = jade.compile fs.readFileSync(file, "utf-8"), { filename: file }

      html   = render(options.locals)
    catch e
      console.error e
      return callback? e, null

    email  =
      to: options.to
      from: config.email.from
      subject: options.subject or 'No Subject'
      html: html

    transport.sendMail email, (err, data) ->
      console.error err if err

      if env is "development"
        # open a preview of the message
        # not too worried about if this is async friendly or not, since it's dev only

        render = jade.compile fs.readFileSync(path.join(__dirname, "views", "email.preview.jade"), "utf-8")
        save   = render { message: data.response.toString() }

        dir = path.join(config.root, ".tmp", "mail", (new Date).toISOString().replace(/[-:TZ\.]/g, ''))
        mkdirp.sync dir

        filename = path.join dir, "message.html"
        fs.writeFileSync filename, save, 'utf-8'
        open filename

      callback?(err, data)

  transport
