"use strict"

mongoose = require("mongoose-bird")()
Schema   = mongoose.Schema
crypto   = require "crypto"

UserSchema = new Schema
  email:
    type: String
    lowercase: true
  role:
    type: String
    default: "user"
  password:
    type: String
    select: false
  provider: String
  salt:
    type: String
    select: false
  resetPasswordToken:
    type: String
    select: false
  resetPasswordSent:
    type: Date
    select: false
  created:
    type: Date
    default: Date.now
  updated: Date
  lastLogin:
    type: Date
    select: false
  failedLoginAttempts:
    type: Number
    default: 0
    select: false

# Virtuals

# Public profile information
UserSchema.virtual("profile").get ->
  role: @role

# Non-sensitive info we'll be putting in the token
UserSchema.virtual("token").get ->
  _id: @_id
  role: @role

# Check if account is locked due to too many login attempts
UserSchema.virtual("locked").get ->
  HOUR = 60 * 60 * 1000
  # too many login attempts and last attempt was less then an hour ago
  @failedLoginAttempts > 5 and ((new Date) - @lastLogin) < (HOUR)

# Validate empty email
UserSchema.path("email").validate (email) ->
  email.length
, "Email cannot be blank"

# Validate empty password
UserSchema.path("password").validate (password) ->
  password.length
, "Password cannot be blank"

# Validate email is not taken
UserSchema.path("email").validate (value, respond) ->
  self = this
  @constructor.findOneAsync email: value
    .then (user) ->
      if user
        return respond true if self.id is user.id
        return respond false
      respond true
    .catch (err) ->
      throw err
, "The specified email address is already in use."

validatePresenceOf = (value) ->
  value and value.length

# Pre-save hook
UserSchema.pre "save", (next) ->
  @updated = new Date()

  if @password
    return next new Error("Invalid password") unless validatePresenceOf(@password)

    _this = this
    @makeSalt (saltErr, salt) ->
      return next saltErr if saltErr
      _this.salt = salt
      _this.encryptPassword _this.password, (encryptErr, hashedPassword) ->
        return next encryptErr if encryptErr
        _this.password = hashedPassword
        next()
  else
    next()


# Methods
UserSchema.methods =

  # Authenticate - check if the passwords are the same
  authenticate: (password, callback) ->
    return @encryptPassword(password) is @password unless callback

    _this = this
    @encryptPassword password, (err, pwdGen) ->
      return callback err if err
      if pwdGen is _this.password
        callback null, true
      else
        callback null, false

    return

  makeSalt: (byteSize, callback) ->
    defaultByteSize = 16

    if typeof arguments[0] is "function"
      callback = arguments[0]
      byteSize = defaultByteSize
    else callback = arguments[1] if typeof arguments[1] is "function"

    byteSize = defaultByteSize unless byteSize

    return crypto.randomBytes(byteSize).toString "base64" unless callback
    crypto.randomBytes byteSize, (err, salt) ->
      return callback err if err
      callback null, salt.toString "base64"

  # Encrypt pass
  encryptPassword: (password, callback) ->
    return null if not password or not @salt

    defaultIterations = 10000
    defaultKeyLength = 64
    salt = new Buffer @salt, "base64"

    return crypto.pbkdf2Sync(password, salt, defaultIterations, defaultKeyLength).toString "base64" unless callback

    crypto.pbkdf2 password, salt, defaultIterations, defaultKeyLength, (err, key) ->
      return callback err if err
      callback null, key.toString "base64"

  # Generate reset password token and set created at
  generateResetPasswordToken: ->
    uniqueString = -> ("0000" + (Math.random() * Math.pow(36, 4) << 0).toString(36)).slice(-4)
    @resetPasswordToken = uniqueString() + uniqueString() + uniqueString() + uniqueString()
    @resetPasswordSent = new Date()
    return

  # Check if reset token is still valid
  checkResetToken: (token, callback) ->
    HOUR = 60 * 60 * 1000
    dateValid = ((new Date) - @resetPasswordSent) < (HOUR * 3)
    return (token is @resetPasswordToken and dateValid) unless callback
    callback (token is @resetPasswordToken and dateValid)


module.exports = mongoose.model "User", UserSchema
