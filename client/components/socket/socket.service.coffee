'use strict'

angular.module 'miriClientServerApp'
.service 'Socket', ($rootScope, ENV, $cookieStore) ->
  class SocketService
    @ws: null

    @connect: (callback) ->
      if window["WebSocket"]
        @ws = new WebSocket("ws://" + ENV.api + "?access_token=" + $cookieStore.get 'token')

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

          # @todo temporary
          console.log msg

          eventName = if msg.response_to.length > 0 then msg.response_to else "general_message"
          $rootScope.$broadcast 'ws.' + msg.response_to, msg
      return

    @connected: ->
      @ws["send"]

    @send: (msg) ->
      @ws.send JSON.stringify(msg)

    @disconnect: ->
      @ws.disconnect()

  return SocketService
