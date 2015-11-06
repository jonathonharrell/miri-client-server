'use strict'

app     = require "../../app"
User    = require "./user.model"

user = new User
  provider: 'local'
  email: 'test@test.com'
  password: 'password'

describe "User Model", ->
  before ->
    # Clear users before testing
    User.remove().exec()

  afterEach ->
    User.remove().exec()

  it "should begin with no users", ->
    User.findAsync({}).should.eventually.have.length 0

  it "should fail when saving a duplicate user", ->
    user.saveAsync().then(->
      userDup = new User user
      userDup.saveAsync()
    ).should.be.rejected

  it 'should fail when saving without an email', ->
    user.email = ''
    user.saveAsync().should.be.rejected

  it "should authenticate user if password is valid", ->
    user.authenticate('password').should.be.true

  it "should not authenticate user if password is invalid", ->
    user.authenticate('blah').should.not.be.true

  it "should generate a reset password token on request", ->
    user.should.not.have.property "resetPasswordToken"
    user.should.not.have.property "resetPasswordSent"
    user.generateResetPasswordToken()
    user.should.have.property "resetPasswordToken"
    user.should.have.property "resetPasswordSent"

  it "should validate against a reset password token", ->
    res = user.checkResetToken(user.resetPasswordToken)
    res.should.be.true

  it "should fail to validate reset token when the token has expired", ->
    HOUR = 60 * 60 * 1000
    user.resetPasswordSent = new Date((new Date()).getTime() - (HOUR * 4))
    res = user.checkResetToken user.resetPasswordToken
    res.should.be.false

  it "should keep track of last update and created dates", (done) ->
    user.created.should.exist
    user.updated.should.exist
    oldUpdated = user.updated
    user.email = 'test2@test.com'

    user.saveAsync()
      .spread (user) ->
        user.updated.should.not.equal oldUpdated
        done()

  describe "Account locking mechanism", ->

    it "should return false for legit login attempts", ->
      user.locked.should.be.false

    it "should return true after 5 attempts within a certain timeframe", ->
      user.lastLogin = new Date()
      user.failedLoginAttempts = 6
      user.locked.should.be.true

    it "should allow logins after an hour of being locked", ->
      user.lastLogin = (new Date() - 60 * 60 * 1000)
      user.failedLoginAttempts = 6
      user.locked.should.be.false
