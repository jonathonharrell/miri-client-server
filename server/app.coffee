###
Main application file
###

"use strict"

require "coffee-script/register"

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or "development"
express = require "express"
mongoose = require("mongoose-bird")()
config = require "./config/environment"

# Connect to database
mongoose.connect config.mongo.uri, config.mongo.options

# Populate DB with sample data
require "./config/seed"  if config.seedDB

# Setup server
app = express()
server = require("http").createServer(app)

require("./config/express") app
require("./config/nodemailer") app
require("./routes") app

startServer = ->
  # Start server
  server.listen config.port, config.ip, ->
    console.log "Express server listening on %d, in %s mode", config.port, app.get("env")

setImmediate startServer

# Expose app
exports = module.exports = app
