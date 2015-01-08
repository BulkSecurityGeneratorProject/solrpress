"use strict"
angular.module("solrpressApp").controller "PasswordController", ($scope, Auth, Principal, $log) ->
    Principal.identity().then (account) ->
        $scope.account = account
        return

    $scope.success = null
    $scope.error = null
    $scope.doNotMatch = null
    $scope.changePassword = ->
        if $scope.password isnt $scope.confirmPassword
            $scope.doNotMatch = "ERROR"
        else
            $scope.doNotMatch = null
            Auth.changePassword($scope.password)

            .then ->
                $scope.error = null
                $scope.success = "OK"
            .catch ->
                $log.debug arguments
                $scope.error = 'ERROR'
                $scope.success = null
