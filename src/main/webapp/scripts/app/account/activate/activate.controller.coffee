'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'activate',
        parent: 'account'
        url: '/activate?key'
        data:
            roles: []

        views:
            'content@':
                templateUrl: 'scripts/app/account/activate/activate.html'
                controller: 'ActivationController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'activate'
                    return $translate.refresh()
            ]

    return
).controller 'ActivationController', ($scope, $stateParams, Auth) ->
    Auth.activateAccount(key: $stateParams.key).then(->
        $scope.error = null
        $scope.success = 'OK'
        return
    )['catch'] ->
        $scope.success = null
        $scope.error = 'ERROR'
        return

    return


