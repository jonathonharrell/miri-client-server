'use strict'

angular.module 'miriClientServerApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
    authenticate: true

  .state 'main.connect',
    url: 'connect'
    controller: 'ConnectCtrl'
    templateUrl: 'app/main/connect/connect.html'
    authenticate: true

  .state 'main.login',
    url: 'login'
    templateUrl: 'app/account/login/login.html'
    controller: 'LoginCtrl'

  .state 'main.signup',
    url: 'signup'
    templateUrl: 'app/account/signup/signup.html'
    controller: 'SignupCtrl'

  .state 'main.forgotPassword',
    url: 'forgot_password'
    templateUrl: 'app/account/forgotPassword/forgotPassword.html'
    controller: 'ForgotPasswordCtrl'

  .state 'main.resetPassword',
    url: 'reset_password/:resetToken'
    templateUrl: 'app/account/resetPassword/resetPassword.html'
    controller: 'ResetPasswordCtrl'

  .state 'main.account',
    url: 'account'
    templateUrl: 'app/account/settings/account.html'
    controller: 'AccountCtrl'
    authenticate: true

  .state 'main.characterCreate',
    url: 'characters/create'
    templateUrl: 'app/characters/create/create.html'
    controller: 'CharacterCreateCtrl'
    authenticate: true

  .state 'main.characterSelect',
    url: 'characters'
    templateUrl: 'app/characters/select/select.html'
    controller: 'CharacterSelectCtrl'
    authenticate: true

  .state 'main.logout',
    url: '/logout'
    controller: ($state, Auth) ->
      # socketProvider.disconnect() @todo
      Auth.logout()
      $state.go 'main.login'
