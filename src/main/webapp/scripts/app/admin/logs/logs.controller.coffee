'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'logs',
        parent: 'admin'
        url: '/logs'
        data:
            roles: ['ROLE_ADMIN']

        views:
            'content@':
                templateUrl: 'scripts/app/admin/logs/logs.html'
                controller: 'LogsController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'logs'
                    return $translate.refresh()
            ]

    return
).controller 'LogsController', ($scope, LogsService) ->
    $scope.loggers = LogsService.findAll()
    $scope.changeLevel = (name, level) ->
        LogsService.changeLevel
            name: name
            level: level
        , ->
            $scope.loggers = LogsService.findAll()
            return

        return

    return
