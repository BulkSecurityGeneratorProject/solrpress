'use strict'
angular.module('solrpressApp').controller 'AuditsController', ($scope, $translate, $filter, AuditsService) ->

  $scope.onChangeDate = ->
    dateFormat = undefined
    fromDate = undefined
    toDate = undefined
    dateFormat = 'yyyy-MM-dd'
    fromDate = $filter('date')($scope.fromDate, dateFormat)
    toDate = $filter('date')($scope.toDate, dateFormat)
    AuditsService.findByDates(fromDate, toDate).then (data) ->
      $scope.audits = data
      return
    return

  $scope.today = ->
    today = undefined
    today = new Date
    $scope.toDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1)
    return

  $scope.previousMonth = ->
    fromDate = undefined
    fromDate = new Date
    if fromDate.getMonth() == 0
      fromDate = new Date(fromDate.getFullYear() - 1, 0, fromDate.getDate())
    else
      fromDate = new Date(fromDate.getFullYear(), fromDate.getMonth() - 1, fromDate.getDate())
    $scope.fromDate = fromDate
    return

  $scope.today()
  $scope.previousMonth()
  $scope.onChangeDate()
  return
