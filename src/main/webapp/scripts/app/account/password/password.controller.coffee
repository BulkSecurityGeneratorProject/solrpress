'use strict'
angular.module('solrpressApp').controller 'PasswordController', ($scope, Auth, Principal) ->
  Principal.identity().then (account) ->
    $scope.account = account
    return
  $scope.success = null
  $scope.error = null
  $scope.doNotMatch = null

  $scope.changePassword = ->
    if $scope.password != $scope.confirmPassword
      $scope.doNotMatch = 'ERROR'
    else
      $scope.doNotMatch = null
      Auth.changePassword($scope.password).then(->
        $scope.error = null
        $scope.success = 'OK'
        return
      )['catch'] ->
        $scope.success = null
        $scope.error = 'ERROR'
        return
    return

  return
