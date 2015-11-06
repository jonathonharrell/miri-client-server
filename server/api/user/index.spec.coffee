"use strict"

proxyquire = require("proxyquire").noPreserveCache()

userCtrlStub =
  index: "userCtrl.index"
  destroy: "userCtrl.destroy"
  me: "userCtrl.me"
  changePassword: "userCtrl.changePassword"
  changeEmail: "userCtrl.changeEmail"
  resetPassword: "userCtrl.resetPassword"
  forgotPassword: "userCtrl.forgotPassword"
  show: "userCtrl.show"
  create: "userCtrl.create"

authServiceStub =
  isAuthenticated: ->
    "authService.isAuthenticated"

  hasRole: (role) ->
    "authService.hasRole." + role

routerStub =
  get: sinon.spy()
  put: sinon.spy()
  post: sinon.spy()
  delete: sinon.spy()

# require the index with our stubbed out modules
userIndex = proxyquire("./index",
  express:
    Router: ->
      routerStub

  "./user.controller": userCtrlStub
  "../../auth/auth.service": authServiceStub
)

describe "User API Router:", ->

  it "should return an express router instance", ->
    userIndex.should.equal routerStub
    return

  describe "GET /api/users", ->
    it "should verify admin role and route to user.controller.index", ->
      routerStub.get.withArgs("/", "authService.hasRole.admin", "userCtrl.index")
      .should.have.been.calledOnce

  describe "DELETE /api/users/:id", ->
    it "should verify admin role and route to user.controller.destroy", ->
      routerStub.delete
        .withArgs('/:id', 'authService.hasRole.admin', 'userCtrl.destroy')
        .should.have.been.calledOnce;

  describe "GET /api/users/me", ->
    it "should be authenticated and route to user.controller.me", ->
      routerStub.get
        .withArgs("/me", "authService.isAuthenticated", "userCtrl.me")
        .should.have.been.calledOnce

  describe "POST /api/users/forgot", ->
    it "should route to user.controller.forgotPassword", ->
      routerStub.post
        .withArgs("/forgot", "userCtrl.forgotPassword")
        .should.have.been.calledOnce

  describe "PUT /api/users/reset/:resetToken", ->
    it "should route to user.controller.resetPassword", ->
      routerStub.put
        .withArgs("/reset/:resetToken", "userCtrl.resetPassword")
        .should.have.been.calledOnce

  describe "PUT /api/users/:id/password", ->
    it "should be authenticated and route to user.controller.changePassword", ->
      routerStub.put
        .withArgs("/:id/password", "authService.isAuthenticated", "userCtrl.changePassword")
        .should.have.been.calledOnce

  describe "PUT /api/users/:id/email", ->
    it "should be authenticated and route to user.controller.changeEmail", ->
      routerStub.put
        .withArgs "/:id/email", "authService.isAuthenticated", "userCtrl.changeEmail"
        .should.have.been.calledOnce

  describe "GET /api/users/:id", ->
    it "should be authenticated and route to user.controller.show", ->
      routerStub.get
        .withArgs("/:id", "authService.isAuthenticated", "userCtrl.show")
        .should.have.been.calledOnce

  describe "POST /api/users", ->
    it "should route to user.controller.create", ->
      routerStub.post
        .withArgs("/", "userCtrl.create")
        .should.have.been.calledOnce
