'use strict'

angular.module 'miriClientServerApp'
.directive 'trait', ->
  restrict: 'EA'
  scope:
    traitIcon: '='
  link: (scope, element) ->
    per = 16 # 512/32
    row = Math.round((scope.traitIcon - 1) / per)
    column = (scope.traitIcon - (row * 16) - 1) * 32
    position = '-' + String(column) + 'px -' + String(row) + 'px'

    element.css
      background: 'url(\'/assets/images/traits.png\') ' + position + ' no-repeat'

    # @todo tooltip
