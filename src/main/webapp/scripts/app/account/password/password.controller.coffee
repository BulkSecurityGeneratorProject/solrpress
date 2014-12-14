'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'password',
        parent: 'account'
        url: '/password'
        data:
            roles: ['ROLE_USER']

        views:
            'content@':
                templateUrl: 'scripts/app/account/password/password.html'
                controller: 'PasswordController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'password'
                    return $translate.refresh()
            ]

    return
).controller 'PasswordController', ($scope, Auth, Principal) ->
    Principal.identity().then (account) ->
        $scope.account = account
        return

    $scope.success = null
    $scope.error = null
    $scope.doNotMatch = null
    $scope.changePassword = ->
        unless $scope.password is $scope.confirmPassword
            $scope.doNotMatch = 'ERROR'
        else
            $scope.doNotMatch = null
            Auth.changePassword($scope.password).then                $scope.error = null
                $scope.success = 'OK'
                return
            )['catch'] ->
                $scope.success = null
                $scope.error = 'ERROR'
                return

        return

    return

