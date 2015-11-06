'use strict'

@nanobar = new Nanobar(
  id: 'nano'
)

angular.module 'miriClientServerApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.router',
  'ui.bootstrap',
  'config'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider
  .otherwise '/'

  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'

.factory 'authInterceptor', ($rootScope, $q, $cookieStore, $injector) ->
  state = null
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + $cookieStore.get 'token' if $cookieStore.get 'token'
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      (state || state = $injector.get '$state').go 'main.login'
      # remove any stale tokens
      $cookieStore.remove 'token'

    $q.reject response

.run ($rootScope, Auth, $state) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, next) ->
    Auth.isLoggedIn (loggedIn) ->
      if next.authenticate and not loggedIn and next.name isnt "login"
        event.preventDefault()
        $state.go "main.login"

    nanobar.go 30

  $rootScope.$on '$stateChangeSuccess', (event, next) ->
    nanobar.go 100
