'use strict'

angular.module 'miriClientServerApp'
.factory 'User', ($resource) ->
  $resource '/api/users/:id/:controller',
    id: '@_id'
  ,
    changePassword:
      method: 'PUT'
      params:
        controller: 'password'

    changeEmail:
      method: 'PUT'
      params:
        controller: 'email'

    get:
      method: 'GET'
      params:
        id: 'me'
