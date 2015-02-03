'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'audits',
    parent: 'admin'
    url: '/audits'
    data: roles: [ 'ROLE_ADMIN' ]
    views: 'content@':
      templateUrl: 'scripts/app/admin/audits/audits.html'
      controller: 'AuditsController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'audits'
        $translate.refresh()
    ]
  return
