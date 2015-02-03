'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'configuration',
    parent: 'admin'
    url: '/configuration'
    data: roles: [ 'ROLE_ADMIN' ]
    views: 'content@':
      templateUrl: 'scripts/app/admin/configuration/configuration.html'
      controller: 'ConfigurationController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'configuration'
        $translate.refresh()
    ]
  return
