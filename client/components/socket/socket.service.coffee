'use strict'

angular.module 'miriClientServerApp'
.service 'Socket', ($rootScope) ->
  class SocketService
    @ws: null

    @connect: (callback) ->
      if window["WebSocket"]
        @ws = new WebSocket("ws://localhost:8080")
        callback "Connected"

        @ws.onmessage = (m) ->
          msg = JSON.parse m.data
          $rootScope.$broadcast 'ws.' + msg.response_to, msg
      return

    @connected: ->
      @ws["send"]

    @send: (msg) ->
      @ws.send JSON.stringify(msg)

  return SocketService
