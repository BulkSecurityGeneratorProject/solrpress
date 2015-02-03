'use strict'
angular.module('solrpressApp').controller 'ActivationController', ($scope, $stateParams, Auth) ->
  Auth.activateAccount(key: $stateParams.key).then(->
    $scope.error = null
    $scope.success = 'OK'
    return
  )['catch'] ->
    $scope.success = null
    $scope.error = 'ERROR'
    return
  return
