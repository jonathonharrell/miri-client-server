'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterSelectCtrl', ($scope, $http, ENV) ->
  api = window.location.protocol + '//' + ENV.api
  $scope.characters = []

  $http.get api + '/characters/list'
  .then (res) ->
    console.log res.data

  $scope.select_character = (id) ->
    console.log id
