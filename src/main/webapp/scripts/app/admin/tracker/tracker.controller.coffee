'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'tracker',
        parent: 'admin'
        url: '/tracker'
        data:
            roles: ['ROLE_ADMIN']

        views:
            'content@':
                templateUrl: 'scripts/app/admin/tracker/tracker.html'
                controller: 'TrackerController'

        resolve:
            mainTranslatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'tracker'
                    return $translate.refresh()
            ]

    return
).controller 'TrackerController', ($scope) ->
    $scope.activities = []
    $scope.trackerSocket = atmosphere
    $scope.trackerSubSocket
    $scope.trackerTransport = 'websocket'
    $scope.trackerRequest =
        url: 'websocket/tracker'
        contentType: 'application/json'
        transport: $scope.trackerTransport
        trackMessageLength: true
        reconnectInterval: 5000
        enableXDR: true
        timeout: 60000

    $scope.trackerRequest.onOpen = (response) ->
        $scope.trackerTransport = response.transport
        $scope.trackerRequest.uuid = response.request.uuid
        return

    $scope.trackerRequest.onMessage = (response) ->
        activity = undefined
        existingActivity = undefined
        index = undefined
        message = undefined
        message = response.responseBody
        activity = atmosphere.util.parseJSON(message)
        existingActivity = false
        index = 0
        while index < $scope.activities.length
            if $scope.activities[index].uuid is activity.uuid
                existingActivity = true
                if activity.page is 'logout'
                    $scope.activities.splice index, 1
                else
                    $scope.activities[index] = activity
            index++
        $scope.activities.push activity  unless existingActivity
        $scope.$apply()
        return

    $scope.trackerSubSocket = $scope.trackerSocket.subscribe($scope.trackerRequest)
    return
