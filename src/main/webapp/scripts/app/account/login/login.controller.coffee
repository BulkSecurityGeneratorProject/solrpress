'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'login',
        parent: 'account'
        url: '/login'
        data:
            roles: []

        views:
            'content@':
                templateUrl: 'scripts/app/account/login/login.html'
                controller: 'LoginController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'login'
                    return $translate.refresh()
            ]

    return
).controller 'LoginController', ($rootScope, $scope, $state, Auth) ->
    $scope.user = {}
    $scope.errors = {}
    $scope.rememberMe = true
    $scope.login = ->
        Auth.login(
            username: $scope.username
            password: $scope.password
            rememberMe: $scope.rememberMe
        ).then            $scope.authenticationError = false
            $rootScope.back()
            return
        )['catch'] (err) ->
            $scope.authenticationError = true
            return

        return

    return

