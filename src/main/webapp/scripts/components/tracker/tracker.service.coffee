"use strict"

angular.module("solrpressApp").factory "Tracker", ($rootScope) ->
    sendActivity = ->
        stompClient.send "/websocket/activity", {}, JSON.stringify(page: $rootScope.toState.name)
        return
    stompClient = null
    connect: ->
        socket = new SockJS("/websocket/activity")
        stompClient = Stomp.over(socket)
        stompClient.connect {}, (frame) ->
            sendActivity()
            $rootScope.$on "$stateChangeStart", (event) ->
                sendActivity()
                return

            return

        return

    sendActivity: ->
        sendActivity()  if stompClient?
        return

    disconnect: ->
        if stompClient?
            stompClient.disconnect()
            not stompClient?
        return

