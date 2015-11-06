'use strict'

express = require "express"
passport = require "passport"
auth = require "../auth.service"

router = express.Router()

router.post '/', (req, res, next) ->
  passport.authenticate('local', (err, user, info) ->
    error = err or info
    return res.status(401).json error if error
    return res.status(404).json {message: 'Something went wrong, please try again.'} unless user

    token = auth.signToken user._id, user.role
    res.json {token: token}
  )(req, res, next)


module.exports = router
