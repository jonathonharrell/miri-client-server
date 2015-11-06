'use strict';

express    = require 'express'
controller = require './user.controller'
config     = require '../../config/environment'
auth       = require '../../auth/auth.service'
router     = express.Router()

router.get '/', auth.hasRole('admin'), controller.index
router.delete '/:id', auth.hasRole('admin'), controller.destroy
router.get '/me', auth.isAuthenticated(), controller.me
router.post '/forgot', controller.forgotPassword
router.put '/reset/:resetToken', controller.resetPassword
router.put '/:id/password', auth.isAuthenticated(), controller.changePassword
router.put '/:id/email', auth.isAuthenticated(), controller.changeEmail
router.get '/:id', auth.isAuthenticated(), controller.show
router.post '/', controller.create

module.exports = router
