'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'health',
        parent: 'admin'
        url: '/health'
        data:
            roles: ['ROLE_ADMIN']

        views:
            'content@':
                templateUrl: 'scripts/app/admin/health/health.html'
                controller: 'HealthController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'health'
                    return $translate.refresh()
            ]

    return
).controller 'HealthController', ($scope, MonitoringService) ->
    $scope.updatingHealth = true
    $scope.refresh = ->
        $scope.updatingHealth = true
        MonitoringService.checkHealth().then ((reponse) ->
            $scope.healthCheck = reponse
            $scope.updatingHealth = false
            return
        ), (reponse) ->
            $scope.healthCheck = reponse.data
            $scope.updatingHealth = false
            return

        return

    $scope.refresh()
    $scope.getLabelClass = (statusState) ->
        if statusState is 'UP'
            'label-success'
        else
            'label-danger'

    return
