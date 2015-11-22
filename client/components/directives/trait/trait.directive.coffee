'use strict'

angular.module 'miriClientServerApp'
.directive 'trait', ->
  restrict: 'EA'
  scope:
    trait: '=',
    category: '='
  link: (scope, element) ->
    traits = [
      "HAIRCOLOR - BROWN",
      "HAIRCOLOR - BLONDE",
      "HAIRCOLOR - GREY",
      "HAIRCOLOR - BLACK",
    ]

    icon = traits.indexOf(scope.category + ' - ' + scope.trait) + 1
    per = 16 # 512/32
    row = Math.round((icon - 1) / per)
    column = (icon - (row * 16) - 1) * 32
    position = '-' + String(column) + 'px -' + String(row) + 'px'

    unless icon < 1 or icon > 256
      element.css
        background: 'url(\'/assets/images/traits.png\') ' + position + ' no-repeat'
    else
      element.css
        background: 'url(\'http://placehold.it/32x32\') center no-repeat'

    # @todo handle tooltip
