'use strict'

angular.module 'miriClientServerApp'
.service 'Socket', ($rootScope) ->
  class SocketService
    @ws: null

    @connect: (callback) ->
      if window["WebSocket"]
        @ws = new WebSocket("ws://localhost:8080")

        self = @
        @ws.onclose = (e) ->
          if e.code is 1006
            $rootScope.$broadcast 'ws.unexpected_close', 'The connection was closed abnormally, the server may be down for maintanence.'
          else
            console.log e

        @ws.onopen = ->
          callback "Connected"

        @ws.onmessage = (m) ->
          msg = JSON.parse m.data
          eventName = if msg.response_to.length > 0 then msg.response_to else "general_message"
          $rootScope.$broadcast 'ws.' + msg.response_to, msg
      return

    @connected: ->
      @ws["send"]

    @send: (msg) ->
      @ws.send JSON.stringify(msg)

  return SocketService
