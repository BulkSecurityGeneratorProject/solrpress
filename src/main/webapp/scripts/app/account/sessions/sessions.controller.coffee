'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'sessions',
        parent: 'account'
        url: '/sessions'
        data:
            roles: ['ROLE_USER']

        views:
            'content@':
                templateUrl: 'scripts/app/account/sessions/sessions.html'
                controller: 'SessionsController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'sessions'
                    return $translate.refresh()
            ]

    return
).controller 'SessionsController', ($scope, Sessions, Principal) ->
    Principal.identity().then (account) ->
        $scope.account = account
        return

    $scope.success = null
    $scope.error = null
    $scope.sessions = Sessions.getAll()
    $scope.invalidate = (series) ->
        Sessions.delete(
            series: encodeURIComponent(series)
        , () ->
            $scope.error = null
            $scope.success = 'OK'
            $scope.sessions = Sessions.getAll()
        , () ->
            $scope.success = null
            $scope.error = 'ERROR'
        )

    return
