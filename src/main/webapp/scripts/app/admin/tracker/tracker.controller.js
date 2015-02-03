angular.module('solrpressApp').controller('TrackerController', function($scope, AuthServerProvider) {
  var showActivity, socket, stompClient;
  showActivity = function(activity) {
    var existingActivity, index;
    existingActivity = false;
    index = 0;
    while (index < $scope.activities.length) {
      if ($scope.activities[index].sessionId === activity.sessionId) {
        existingActivity = true;
        if (activity.page === 'logout') {
          $scope.activities.splice(index, 1);
        } else {
          $scope.activities[index] = activity;
        }
      }
      index++;
    }
    if (!existingActivity && activity.page !== 'logout') {
      $scope.activities.push(activity);
    }
    $scope.$apply();
  };
  $scope.activities = [];
  stompClient = null;
  socket = new SockJS('/websocket/tracker');
  stompClient = Stomp.over(socket);
  stompClient.connect({}, function(frame) {
    stompClient.subscribe('/topic/activity', function(activity) {
      showActivity(JSON.parse(activity.body));
    });
  });
});
