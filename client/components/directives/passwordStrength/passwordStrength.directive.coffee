'use strict'

angular.module 'miriClientServerApp'
.directive 'passwordStrength', ->
  template: '<span class="password-strength"><span class="label label-{{class}}">{{strength}}</span>
  <progressbar value="value" type="{{class}}" class="password-strength"></progressbar></span>'
  restrict: 'EA'
  scope:
    password: "=passwordStrength"
  link: (scope) ->

    characters     = 0
    capitals       = 0
    lowercase      = 0
    number         = 0
    special        = 0

    upperCase      = new RegExp('[A-Z]')
    lowerCase      = new RegExp('[a-z]')
    numbers        = new RegExp('[0-9]')
    specialchars   = new RegExp('([!,%,&,@,#,$,^,*,?,_,~])')

    measureStrength = (password) ->
      total = 0

      if password.length > 3
        if password.length > 11        then characters = 1 else characters = 0
        if password.match upperCase    then capitals   = 1 else capitals   = 0
        if password.match lowerCase    then lowercase  = 1 else lowercase  = 0
        if password.match numbers      then number     = 1 else number     = 0
        if password.match specialchars then special    = 1 else special    = 0
      else
        characters = 0
        capitals   = 0
        lowercase  = 0
        number     = 0
        special    = 0

      total = characters + capitals + lowercase + number + special
      percent = ((total / 5) * 100).toFixed 0

      strengths = ["Very Weak", "Very Weak", "Weak", "Medium", "Strong", "Very Strong"]
      classes = ["default", "danger", "danger", "warning", "success", "primary"]

      { percent: percent, strength: strengths[total], class: classes[total] }

    scope.$watch "password", ->
      data           = measureStrength scope.password
      scope.value    = data.percent
      scope.strength = data.strength
      scope.class    = data.class
