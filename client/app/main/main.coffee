'use strict'

angular.module 'miriClientServerApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'

  .state 'main.login',
    url: 'login'
    templateUrl: 'app/authentication/login.html'
    controller: 'LoginCtrl'

  .state 'main.signup',
    url: 'signup'
    templateUrl: 'app/authentication/signup.html'
    controller: 'SignupCtrl'

  .state 'main.forgot_password',
    url: 'forgot_password'
    templateUrl: 'app/authentication/forgot_password.html'
    controller: 'ForgotPasswordCtrl'

  .state 'main.reset_password',
    url: 'reset_password'
    templateUrl: 'app/main.reset_password.html'
    controller: 'ResetPasswordCtrl'

  .state 'main.account',
    url: 'account'
    templateUrl: 'app/main.account.html'
    controller: 'AccountCtrl'

  .state 'main.character_create',
    url: 'characters/create'
    templateUrl: 'app/main.character_create.html'
    controller: 'CharacterCreateCtrl'

  .state 'main.character_select',
    url: 'characters'
    templateUrl: 'app/main.character_select.html'
    controller: 'CharacterSelectCtrl'
