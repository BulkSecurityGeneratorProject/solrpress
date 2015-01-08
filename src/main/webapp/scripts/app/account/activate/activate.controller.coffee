"use strict"
angular.module("solrpressApp").controller "ActivationController", ($scope, $stateParams, Auth) ->

    Auth.activateAccount(key: $stateParams.key)

    .then ->
        $scope.error = null
        $scope.success = "OK"
    .catch ->
        $scope.error = 'ERROR'
        $scope.success = null

