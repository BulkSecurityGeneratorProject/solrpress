"use strict"

angular.module("solrpressApp").controller "MetricsController", ($scope, MonitoringService) ->
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

    $scope.$watch "metrics", (newValue) ->
        $scope.servicesStats = {}
        $scope.cachesStats = {}
        angular.forEach newValue.timers, (value, key) ->
            $scope.servicesStats[key] = value  if key.indexOf("web.rest") isnt -1 or key.indexOf("service") isnt -1
            if key.indexOf("net.sf.ehcache.Cache") isnt -1

                # remove gets or puts
                index = key.lastIndexOf(".")
                newKey = key.substr(0, index)

                # Keep the name of the domain
                index = newKey.lastIndexOf(".")
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
            angular.forEach data, (value) ->
                if value.threadState is "RUNNABLE"
                    $scope.threadDumpRunnable += 1
                else if value.threadState is "WAITING"
                    $scope.threadDumpWaiting += 1
                else if value.threadState is "TIMED_WAITING"
                    $scope.threadDumpTimedWaiting += 1
                else $scope.threadDumpBlocked += 1  if value.threadState is "BLOCKED"
                return

            $scope.threadDumpAll = $scope.threadDumpRunnable + $scope.threadDumpWaiting + $scope.threadDumpTimedWaiting + $scope.threadDumpBlocked
            return

        return

    $scope.getLabelClass = (threadState) ->
        if threadState is "RUNNABLE"
            "label-success"
        else if threadState is "WAITING"
            "label-info"
        else if threadState is "TIMED_WAITING"
            "label-warning"
        else "label-danger"  if threadState is "BLOCKED"

    return

