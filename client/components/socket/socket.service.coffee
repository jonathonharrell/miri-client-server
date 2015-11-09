'use strict'

angular.module 'miriClientServerApp'
.service 'Socket', ($rootScope, ENV, $cookieStore) ->
  class SocketService
    @ws: null

    @connect: (callback) ->
      if window["WebSocket"]
        @ws = new WebSocket("ws://" + ENV.api + "?access_token=" + $cookieStore.get 'token')

        @ws.onclose = (e) ->
          if e.code is 1006
            $rootScope.$broadcast 'ws.unexpected_close', 'The connection was closed abnormally, the server may be down for maintanence.'
          else
            console.log e

        @ws.onopen = ->
          callback "Connected"

        @ws.onmessage = (m) ->
          msg = if m.data then JSON.parse(m.data) else null

          console.log msg # @todo temporary

          $rootScope.$broadcast 'ws.msg', msg
      return

    @connected: ->
      @ws != null

    @send: (msg) ->
      @ws.send JSON.stringify(msg)

    @disconnect: ->
      @ws.disconnect()

  return SocketService
