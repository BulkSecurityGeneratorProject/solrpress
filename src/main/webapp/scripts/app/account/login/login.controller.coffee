"use strict"
angular.module("solrpressApp").controller "LoginController", ($rootScope, $scope, $state, Auth) ->
    $scope.user = {}
    $scope.errors = {}
    $scope.rememberMe = true
    $scope.login = ->
        Auth.login(
            username: $scope.username
            password: $scope.password
            rememberMe: $scope.rememberMe
        )
        .then ->
            $scope.authenticationError = false
            $rootScope.back()

        .catch ->
