'use strict'

angular.module 'miriClientServerApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
    required_state: "InGame"

  .state 'main.connecting',
    url: 'connecting'
    templateUrl: 'app/main/connecting.html'
    required_state: "Connecting"

  .state 'main.login',
    url: 'login'
    templateUrl: 'app/auth/login.html'
    controller: 'LoginCtrl'
    required_state: "NotAuthenticated"

  .state 'main.signup',
    url: 'signup'
    templateUrl: 'app/auth/signup.html'
    controller: 'SignupCtrl'
    required_state: "NotAuthenticated"

  .state 'main.forgot_password',
    url: 'forgot_password'
    templateUrl: 'app/auth/forgot_password.html'
    controller: 'ForgotPasswordCtrl'
    required_state: "NotAuthenticated"

  .state 'main.reset_password',
    url: 'reset_password'
    templateUrl: 'app/main.reset_password.html'
    controller: 'ResetPasswordCtrl'
    required_state: "NotAuthenticated"

  .state 'main.account',
    url: 'account'
    templateUrl: 'app/main.account.html'
    controller: 'AccountCtrl'
    required_state: "Authenticated"

  .state 'main.character_create',
    url: 'characters/create'
    templateUrl: 'app/characters/create.html'
    controller: 'CharacterCreateCtrl'
    required_state: "Authenticated"

  .state 'main.character_select',
    url: 'characters'
    templateUrl: 'app/characters/select.html'
    controller: 'CharacterSelectCtrl'
    required_state: "Authenticated"
