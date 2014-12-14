'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'configuration',
        parent: 'admin'
        url: '/configuration'
        data:
            roles: ['ROLE_ADMIN']

        views:
            'content@':
                templateUrl: 'scripts/app/admin/configuration/configuration.html'
                controller: 'ConfigurationController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'configuration'
                    return $translate.refresh()
            ]

    return
).controller 'ConfigurationController', ($scope, ConfigurationService) ->
    ConfigurationService.get().then (configuration) ->
        $scope.configuration = configuration
        return

    return

