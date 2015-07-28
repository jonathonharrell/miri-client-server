'use strict'

angular.module 'miriClientServerApp'
.service 'Socket', ->
  class SocketService
    @ws: null

    @connect: ->
      console.log "connecting..."
      if window["WebSocket"]
        console.log "connected"
        @ws = new WebSocket("ws://localhost:8080")

    @send: (msg) ->
      @ws.send msg

  return SocketService
