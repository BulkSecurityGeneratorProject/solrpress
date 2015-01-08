"use strict"

angular.module("solrpressApp").controller "TrackerController", ($scope, AuthServerProvider) ->

    # This controller uses a Websocket connection to receive user activities in real-time.
    showActivity = (activity) ->
        existingActivity = false
        index = 0

        while index < $scope.activities.length
            if $scope.activities[index].sessionId is activity.sessionId
                existingActivity = true
                if activity.page is "logout"
                    $scope.activities.splice index, 1
                else
                    $scope.activities[index] = activity
            index++
        $scope.activities.push activity  if not existingActivity and (activity.page isnt "logout")
        $scope.$apply()
        return
    $scope.activities = []
    stompClient = null
    socket = new SockJS("/websocket/tracker")
    stompClient = Stomp.over(socket)
    stompClient.connect {}, (frame) ->
        stompClient.subscribe "/topic/activity", (activity) ->
            showActivity JSON.parse(activity.body)
            return

        return

    return

