'use strict'

angular.module 'miriClientServerApp'
.factory 'Auth', ($state, UserStates) ->
  state: "Connecting"
  admin: false

  authenticate: (m) ->
    @state = UserStates.Authenticated.name
    $state.go UserStates[@state].defaultState

    @admin = true if m.data.is_admin
