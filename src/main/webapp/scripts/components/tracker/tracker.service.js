'use strict';
angular.module('solrpressApp').factory('Tracker', function($rootScope) {
  var sendActivity, stompClient;
  stompClient = null;
  sendActivity = function() {
    stompClient.send('/websocket/activity', {}, JSON.stringify({
      'page': $rootScope.toState.name
    }));
  };
  return {
    connect: function() {
      var socket;
      socket = new SockJS('/websocket/activity');
      stompClient = Stomp.over(socket);
      stompClient.connect({}, function(frame) {
        sendActivity();
        $rootScope.$on('$stateChangeStart', function(event) {
          sendActivity();
        });
      });
    },
    sendActivity: function() {
      if (stompClient !== null) {
        sendActivity();
      }
    },
    disconnect: function() {
      if (stompClient !== null) {
        stompClient.disconnect();
        stompClient === null;
      }
    }
  };
});
