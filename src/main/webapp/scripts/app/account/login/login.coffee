'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'login',
    parent: 'account'
    url: '/login'
    data:
      roles: []
      pageTitle: 'login.title'
    views: 'content@':
      templateUrl: 'scripts/app/account/login/login.html'
      controller: 'LoginController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'login'
        $translate.refresh()
    ]
  return
