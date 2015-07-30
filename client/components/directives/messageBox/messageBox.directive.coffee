'use strict'

angular.module 'miriClientServerApp'
.directive 'messageBox', ->
  restrict: 'A'
  scope:
    messageBox: '='
  link: (scope, element) ->
    scope.$watchCollection 'messageBox', (newValue) ->
      $(element).scrollTop $(element)[0].scrollHeight
