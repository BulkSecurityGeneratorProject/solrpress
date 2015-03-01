'use strict'
angular.module('solrpressApp').controller 'MetricsController', ($scope, MonitoringService) ->
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

  $scope.$watch 'metrics', (newValue) ->
    $scope.servicesStats = {}
    $scope.cachesStats = {}
    angular.forEach newValue.timers, (value, key) ->
      if key.indexOf('web.rest') != -1 or key.indexOf('service') != -1
        $scope.servicesStats[key] = value
      if key.indexOf('net.sf.ehcache.Cache') != -1
        # remove gets or puts
        index = key.lastIndexOf('.')
        newKey = key.substr(0, index)
        # Keep the name of the domain
        index = newKey.lastIndexOf('.')
        $scope.cachesStats[newKey] =
          'name': newKey.substr(index + 1)
          'value': value
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
        if value.threadState == 'RUNNABLE'
          $scope.threadDumpRunnable += 1
        else if value.threadState == 'WAITING'
          $scope.threadDumpWaiting += 1
        else if value.threadState == 'TIMED_WAITING'
          $scope.threadDumpTimedWaiting += 1
        else if value.threadState == 'BLOCKED'
          $scope.threadDumpBlocked += 1
        return
      $scope.threadDumpAll = $scope.threadDumpRunnable + $scope.threadDumpWaiting + $scope.threadDumpTimedWaiting + $scope.threadDumpBlocked
      return
    return

  $scope.getLabelClass = (threadState) ->
    if threadState == 'RUNNABLE'
      return 'label-success'
    else if threadState == 'WAITING'
      return 'label-info'
    else if threadState == 'TIMED_WAITING'
      return 'label-warning'
    else if threadState == 'BLOCKED'
      return 'label-danger'
    return

  return
