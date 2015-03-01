'use strict'
angular.module('solrpressApp').controller 'SettingsController', ($scope, Principal, Auth) ->
  $scope.success = null
  $scope.error = null
  Principal.identity().then (account) ->
    $scope.settingsAccount = account
    return

  $scope.save = ->
    Auth.updateAccount($scope.settingsAccount).then(->
      $scope.error = null
      $scope.success = 'OK'
      Principal.identity().then (account) ->
        $scope.settingsAccount = account
        return
      return
    ).catch ->
      $scope.success = null
      $scope.error = 'ERROR'
      return
    return

  return
