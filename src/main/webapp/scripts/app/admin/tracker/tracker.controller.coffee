angular.module('solrpressApp').controller 'TrackerController', ($scope, AuthServerProvider) ->
  # This controller uses a Websocket connection to receive user activities in real-time.

  showActivity = (activity) ->
    existingActivity = false
    index = 0
    while index < $scope.activities.length
      if $scope.activities[index].sessionId == activity.sessionId
        existingActivity = true
        if activity.page == 'logout'
          $scope.activities.splice index, 1
        else
          $scope.activities[index] = activity
      index++
    if !existingActivity and activity.page != 'logout'
      $scope.activities.push activity
    $scope.$apply()
    return

  $scope.activities = []
  stompClient = null
  socket = new SockJS('/websocket/tracker')
  stompClient = Stomp.over(socket)
  stompClient.connect {}, (frame) ->
    stompClient.subscribe '/topic/activity', (activity) ->
      showActivity JSON.parse(activity.body)
      return
    return
  return
