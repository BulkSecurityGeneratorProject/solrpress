"use strict"
angular.module("solrpressApp").controller "RegisterController", ($scope, $translate, Auth) ->
    $scope.success = null
    $scope.error = null
    $scope.doNotMatch = null
    $scope.errorUserExists = null
    $scope.registerAccount = {}
    $scope.register = ->
        if $scope.registerAccount.password isnt $scope.confirmPassword
            $scope.doNotMatch = "ERROR"
        else
            $scope.registerAccount.langKey = $translate.use()
            $scope.doNotMatch = null
            $scope.error = null
            $scope.errorUserExists = null
            $scope.errorEmailExists = null
            Auth.createAccount($scope.registerAccount)

            .then ->
                $scope.success = "OK"

            .catch (response) ->
                $scope.success = null
                if response.status is 400 and response.data is "login already in use"
                    $scope.errorUserExists = "ERROR"
                else if response.status is 400 and response.data is "e-mail address already in use"
                    $scope.errorEmailExists = "ERROR"
                else
                    $scope.error = "ERROR"

