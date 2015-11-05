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
    templateUrl: 'app/main/connecting.html'
    authenticate: true

  .state 'main.login',
    url: 'login'
    templateUrl: 'app/auth/login.html'
    controller: 'LoginCtrl'

  .state 'main.signup',
    url: 'signup'
    templateUrl: 'app/auth/signup.html'
    controller: 'SignupCtrl'

  .state 'main.forgot_password',
    url: 'forgot_password'
    templateUrl: 'app/auth/forgot_password.html'
    controller: 'ForgotPasswordCtrl'

  .state 'main.reset_password',
    url: 'reset_password'
    templateUrl: 'app/main.reset_password.html'
    controller: 'ResetPasswordCtrl'

  .state 'main.account',
    url: 'account'
    templateUrl: 'app/main.account.html'
    controller: 'AccountCtrl'
    authenticate: true

  .state 'main.character_create',
    url: 'characters/create'
    templateUrl: 'app/characters/create.html'
    controller: 'CharacterCreateCtrl'
    authenticate: true

  .state 'main.character_select',
    url: 'characters'
    templateUrl: 'app/characters/select.html'
    controller: 'CharacterSelectCtrl'
    authenticate: true
