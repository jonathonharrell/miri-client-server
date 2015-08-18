'use strict'

angular.module 'miriClientServerApp'
.directive 'trait', ->
  restrict: 'EA'
  scope:
    traitIcon: '='
  link: (scope, element) ->
    per = 32 # 512/16
    row = Math.round((scope.traitIcon - 1) / per)
    column = (scope.traitIcon - (row * 32) - 1) * 16
    position = '-' + String(column) + 'px -' + String(row) + 'px'

    element.css
      background: 'url(\'/assets/images/traits.png\') ' + position + ' no-repeat'

    # @todo tooltip
