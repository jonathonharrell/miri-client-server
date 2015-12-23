'use strict'

angular.module 'miriClientServerApp'
.factory 'Static', ($uibModal) ->

  open: (page) ->
    $uibModal.open
      templateUrl: 'components/static/' + page + '.html'
      size: 'lg'
    .result
