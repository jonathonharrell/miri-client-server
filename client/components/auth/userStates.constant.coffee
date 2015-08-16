'use strict'

angular.module 'miriClientServerApp'
.constant 'UserStates',
  Connecting:
    defaultState: "main.connecting"
    name: "Connecting"
  NotAuthenticated:
    defaultState: "main.login"
    name: "NotAuthenticated"
  Authenticated:
    defaultState: "main.character_select"
    name: "Authenticated"
  InGame:
    defaultState: "main"
    name: "InGame"
