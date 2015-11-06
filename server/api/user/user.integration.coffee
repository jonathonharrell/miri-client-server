'use strict'

app  = require "../../app"
User = require "./user.model"
request = require "supertest"


describe "User API:", ->
  user = undefined

  before (done) ->
    User.remove ->
      user = new User
        email: "test@test.com"
        password: "password"

      user.save (err) ->
        return done err if err
        done()

  after ->
    User.remove().exec()

  describe "GET /api/users/me", ->
    token = undefined

    before (done) ->
      request app
        .post "/auth/local"
        .send
          email: "test@test.com"
          password: "password"
        .expect 200
        .expect "Content-Type", /json/
        .end (err, res) ->
          token = res.body.token
          done()

    it "should respond with a user profile when authenticated", (done) ->
      request app
        .get "/api/users/me"
        .set "authorization", "Bearer " + token
        .expect 200
        .expect "Content-Type", /json/
        .end (err, res) ->
          # it should not contain salt, or other sensitive properties
          res.body.should.not.have.property "salt"
          res.body.should.not.have.property "password"
          res.body._id.toString().should.equal user._id.toString()
          done()

    it "should respond with a 401 when not authenticated", (done) ->
      request app
        .get "/api/users/me"
        .expect 401
        .end done

  describe "POST /api/users/forgot", ->

    it "should respond with a 201 when the user is found", (done) ->
      request app
        .post "/api/users/forgot"
        .send { email: "test@test.com" }
        .expect 201
        .end done

    it "should respond with a 404 when the user is not found", (done) ->
      request app
        .post "/api/users/forgot"
        .send { email: "fake-email@test.com" }
        .expect 404
        .end done

  describe "PUT /api/users/reset/:resetToken", ->

    it "should respond with a 404 if the reset token is invalid", (done) ->
      request app
        .put "/api/users/reset/not-a-real-token"
        .expect 404
        .end done

    it "should respond with a 204 for a successful update", (done) ->
      User.findOneAsync { email: "test@test.com" }, "+resetPasswordToken"
        .then (user) ->
          request app
            .put "/api/users/reset/" + user.resetPasswordToken
            .send { newPassword: "whatever" }
            .expect 204
            .end done
