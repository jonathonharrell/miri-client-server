'use strict'

angular.module 'miriClientServerApp'
.directive 'menuButton', ->
  restrict: 'EA'
  scope:
    icon: '='
  link: (scope, element) ->
    per = 16 # 512/32
    row = Math.round((scope.icon - 1) / per)
    column = (scope.icon - (row * 16) - 1) * 32
    position = '-' + String(column) + 'px -' + String(row) + 'px'

    unless scope.icon < 0 or scope.icon > 256
      element.css
        background: 'url(\'/assets/images/menu_buttons.png\') ' + position + ' no-repeat'
    else
      element.css
        background: 'url(\'http://placehold.it/32x32\') center no-repeat'

    # @todo handle tooltip
