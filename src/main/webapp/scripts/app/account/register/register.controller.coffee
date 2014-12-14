'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'register',
        parent: 'account'
        url: '/register'
        data:
            roles: []

        views:
            'content@':
                templateUrl: 'scripts/app/account/register/register.html'
                controller: 'RegisterController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'register'
                    return $translate.refresh()
            ]

    return
).controller 'RegisterController', ($scope, $translate, Auth) ->
    $scope.success = null
    $scope.error = null
    $scope.doNotMatch = null
    $scope.errorUserExists = null
    $scope.registerAccount = {}
    $scope.register = ->
        unless $scope.registerAccount.password is $scope.confirmPassword
            $scope.doNotMatch = 'ERROR'
        else
            $scope.registerAccount.langKey = $translate.use()
            $scope.doNotMatch = null
            $scope.error = null
            $scope.errorUserExists = null
            $scope.errorEmailExists = null
            Auth.createAccount($scope.registerAccount).then((account) ->
                $scope.success = 'OK'
                return
            )['catch'] (response) ->
                $scope.success = null
                if response.status is 400 and response.data is 'login already in use'
                    $scope.errorUserExists = 'ERROR'
                else if response.status is 400 and response.data is 'e-mail address already in use'
                    $scope.errorEmailExists = 'ERROR'
                else
                    $scope.error = 'ERROR'
                return

        return

    return

