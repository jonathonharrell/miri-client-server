'use strict'

describe 'Directive: passwordStrength', ->

  # load the directive's module
  beforeEach module 'miriClientServerApp'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should display a progressbar and a label', inject ($compile) ->
    scope.password = "whatever"
    element = angular.element '<div password-strength="password"></div>'
    element = $compile(element) scope
    scope.$digest()
    expect(element.find('div.password-strength').length).toBe 1
    expect(element.find('.label').length).toBe 1

  it 'should display appropriate strength string for different passwords', inject ($compile) ->
    scope.password = "bad"
    element = angular.element '<div password-strength="password"></div>'
    element = $compile(element) scope
    scope.$digest()
    expect(element.find('.label').text()).toBe "Very Weak"

    scope.password = "bad1"
    scope.$digest()
    expect(element.find('.label').text()).toBe "Weak"

    scope.password = "bad1_"
    scope.$digest()
    expect(element.find('.label').text()).toBe "Medium"

    scope.password = "bad1_L"
    scope.$digest()
    expect(element.find('.label').text()).toBe "Strong"

    scope.password = "bad1_LongPassword"
    scope.$digest()
    expect(element.find('.label').text()).toBe "Very Strong"
