"use strict"
angular.module("solrpressApp").controller "SettingsController", ($scope, Principal, Auth, $log) ->
    $scope.success = null
    $scope.error = null
    Principal.identity().then (account) ->
        $scope.settingsAccount = account
        return

    $scope.save = ->
        Auth.updateAccount($scope.settingsAccount).then ->
            $scope.error = null
            $scope.success = "OK"
            Principal.identity()
            .then (account) ->
                $scope.settingsAccount = account
                return
            .catch ->
                $log.debug arguments
                $scope.success = null
                $scope.error = 'ERROR'
