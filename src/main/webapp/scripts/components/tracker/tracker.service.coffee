'use strict'
angular.module('solrpressApp').factory 'Tracker', ($rootScope) ->
  stompClient = null

  sendActivity = ->
    stompClient.send '/websocket/activity', {}, JSON.stringify('page': $rootScope.toState.name)
    return

  {
    connect: ->
      socket = new SockJS('/websocket/activity')
      stompClient = Stomp.over(socket)
      stompClient.connect {}, (frame) ->
        sendActivity()
        $rootScope.$on '$stateChangeStart', (event) ->
          sendActivity()
          return
        return
      return
    sendActivity: ->
      if stompClient != null
        sendActivity()
      return
    disconnect: ->
      if stompClient != null
        stompClient.disconnect()
        stompClient == null
      return

  }
