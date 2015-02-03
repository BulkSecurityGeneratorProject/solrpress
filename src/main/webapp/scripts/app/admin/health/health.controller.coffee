'use strict'
angular.module('solrpressApp').controller 'HealthController', ($scope, MonitoringService) ->
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
    if statusState == 'UP'
      'label-success'
    else
      'label-danger'

  return
