'use strict'

angular.module 'miriClientServerApp'
.controller 'CharacterCreateCtrl', ($scope, $state, Auth, UserStates, Socket) ->
  $scope.step = 0
  $scope.step_titles = ['Race', 'Gender', 'Aesthetic Traits', 'Functional Traits', 'Background', 'Name']
  $scope.races = []

  $scope.race_select = (r) ->
    $scope.selected_race = r

  Socket.send
    command: "charcreate"

  $scope.$on "ws.charcreate", (e, m) ->
    if $scope.step is 0
      $scope.races = m.data
      $scope.selected_race = $scope.races[0]
