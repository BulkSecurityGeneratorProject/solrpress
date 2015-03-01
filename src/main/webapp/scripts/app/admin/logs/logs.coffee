'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'logs',
    parent: 'admin'
    url: '/logs'
    data:
      roles: [ 'ROLE_ADMIN' ]
      pageTitle: 'logs.title'
    views: 'content@':
      templateUrl: 'scripts/app/admin/logs/logs.html'
      controller: 'LogsController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'logs'
        $translate.refresh()
    ]
  return
