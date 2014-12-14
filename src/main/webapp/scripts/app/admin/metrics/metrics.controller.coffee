'use strict'
angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'metrics',
        parent: 'admin'
        url: '/metrics'
        data:
            roles: ['ROLE_ADMIN']

        views:
            'content@':
                templateUrl: 'scripts/app/admin/metrics/metrics.html'
                controller: 'MetricsController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'metrics'
                    return $translate.refresh()
            ]

    return
).controller 'MetricsController', ($scope, MonitoringService) ->
    $scope.metrics = {}
    $scope.updatingMetrics = true
    $scope.refresh = ->
        $scope.updatingMetrics = true
        MonitoringService.getMetrics().then ((promise) ->
            $scope.metrics = promise
            $scope.updatingMetrics = false
            return
        ), (promise) ->
            $scope.metrics = promise.data
            $scope.updatingMetrics = false
            return

        return

    $scope.$watch 'metrics', (newValue, oldValue) ->
        $scope.servicesStats = {}
        $scope.cachesStats = {}
        angular.forEach newValue.timers, (value, key) ->
            index = undefined
            newKey = undefined
            $scope.servicesStats[key] = value  if key.indexOf('web.rest') isnt -1 or key.indexOf('service') isnt -1
            if key.indexOf('net.sf.ehcache.Cache') isnt -1
                index = key.lastIndexOf('.')
                newKey = key.substr(0, index)
                index = newKey.lastIndexOf('.')
                $scope.cachesStats[newKey] =
                    name: newKey.substr(index + 1)
                    value: value
            return

        return

    $scope.refresh()
    $scope.refreshThreadDumpData = ->
        MonitoringService.threadDump().then (data) ->
            $scope.threadDump = data
            $scope.threadDumpRunnable = 0
            $scope.threadDumpWaiting = 0
            $scope.threadDumpTimedWaiting = 0
            $scope.threadDumpBlocked = 0
            angular.forEach data, (value, key) ->
                if value.threadState is 'RUNNABLE'
                    $scope.threadDumpRunnable += 1
                else if value.threadState is 'WAITING'
                    $scope.threadDumpWaiting += 1
                else if value.threadState is 'TIMED_WAITING'
                    $scope.threadDumpTimedWaiting += 1
                else
                    $scope.threadDumpBlocked += 1  if value.threadState is 'BLOCKED'
                return

            $scope.threadDumpAll = $scope.threadDumpRunnable + $scope.threadDumpWaiting + $scope.threadDumpTimedWaiting + $scope.threadDumpBlocked
            return

        return

    $scope.getLabelClass = (threadState) ->
        if threadState is 'RUNNABLE'
            'label-success'
        else if threadState is 'WAITING'
            'label-info'
        else if threadState is 'TIMED_WAITING'
            'label-warning'
        else
            'label-danger'  if threadState is 'BLOCKED'

    return
