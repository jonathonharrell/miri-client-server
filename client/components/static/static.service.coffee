'use strict'

angular.module 'miriClientServerApp'
.factory 'Static', ($modal) ->

  open: (page) ->
    $modal.open
      templateUrl: 'components/static/' + page + '.html'
      size: 'lg'
    .result
