'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'home',
        parent: 'site'
        url: '/'
        data:
            roles: []

        views:
            'content@':
                templateUrl: 'scripts/app/main/main.html'
                controller: 'MainController'

        resolve:
            mainTranslatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'main'
                    return $translate.refresh()
            ]

    return
).controller 'MainController', ($scope, Principal) ->
    Principal.identity().then (account) ->
        $scope.account = account
        $scope.isAuthenticated = Principal.isAuthenticated
        return

    return
