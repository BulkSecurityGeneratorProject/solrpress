'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'settings',
        parent: 'account'
        url: '/settings'
        data:
            roles: ['ROLE_USER']

        views:
            'content@':
                templateUrl: 'scripts/app/account/settings/settings.html'
                controller: 'SettingsController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'settings'
                    return $translate.refresh()
            ]

    return
).controller 'SettingsController', ($scope, Principal, Auth) ->
    $scope.success = null
    $scope.error = null
    Principal.identity().then (account) ->
        $scope.settingsAccount = account
        return

    $scope.save = ->
        Auth.updateAccount($scope.settingsAccount).then            $scope.error = null
            $scope.success = 'OK'
            Principal.identity().then (account) ->
                $scope.settingsAccount = account
                return

            return
        )['catch'] ->
            $scope.success = null
            $scope.error = 'ERROR'
            return

        return

    return

