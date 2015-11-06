###*
  Populate DB with sample data on server start
  to disable, edit config/environment/index.js, and set `seedDB: false`
###

'use strict'

User = require "../api/user/user.model"

User.create
  provider: 'local',
  role: 'admin',
  email: 'superadmin@minimiri.com',
  password: 'superadmin'
, ->
    console.log "finished populating users"
