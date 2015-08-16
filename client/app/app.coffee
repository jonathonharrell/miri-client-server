'use strict'

angular.module 'miriClientServerApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.router',
  'ui.bootstrap'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider
  .otherwise '/'

  $locationProvider.html5Mode true

.run ($rootScope, Auth, UserStates, $state) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, next) ->
    if next.required_state isnt Auth.state
      event.preventDefault()
      $state.go UserStates[Auth.state].defaultState
