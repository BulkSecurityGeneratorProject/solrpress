'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'activate',
    parent: 'account'
    url: '/activate?key'
    data:
      roles: []
      pageTitle: 'activate.title'
    views: 'content@':
      templateUrl: 'scripts/app/account/activate/activate.html'
      controller: 'ActivationController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'activate'
        $translate.refresh()
    ]
  return
