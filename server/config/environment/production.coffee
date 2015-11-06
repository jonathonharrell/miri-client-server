'use strict'

# Production specific configuration
module.exports =
  # Server IP
  ip: process.env.OPENSHIFT_NODEJS_IP or process.env.IP or undefined

  # Server port
  port: process.env.OPENSHIFT_NODEJS_PORT or process.env.PORT or 8080

  # MongoDB connection options
  mongo:
    uri: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or 'mongodb://localhost/miri'

  baseUrl: 'http://minimiri.com'
