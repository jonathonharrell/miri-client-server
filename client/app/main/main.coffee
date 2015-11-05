'use strict'

angular.module 'miriClientServerApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
    authenticate: true

  .state 'main.connecting',
    url: 'connecting'
    controller: 'ConnectingCtrl'
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

  .state 'main.forgot_password',
    url: 'forgot_password'
    templateUrl: 'app/account/forgotPassword/forgotPassword.html'
    controller: 'ForgotPasswordCtrl'

  .state 'main.reset_password',
    url: 'reset_password'
    templateUrl: 'app/account/resetPassword/resetPassword.html'
    controller: 'ResetPasswordCtrl'

  .state 'main.account',
    url: 'account'
    templateUrl: 'app/account/settings/settings.html'
    controller: 'AccountCtrl'
    authenticate: true

  .state 'main.character_create',
    url: 'characters/create'
    templateUrl: 'app/characters/create/create.html'
    controller: 'CharacterCreateCtrl'
    authenticate: true

  .state 'main.character_select',
    url: 'characters'
    templateUrl: 'app/characters/select/select.html'
    controller: 'CharacterSelectCtrl'
    authenticate: true
