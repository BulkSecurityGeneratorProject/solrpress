'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'sessions',
    parent: 'account'
    url: '/sessions'
    data:
      roles: [ 'ROLE_USER' ]
      pageTitle: 'global.menu.account.sessions'
    views: 'content@':
      templateUrl: 'scripts/app/account/sessions/sessions.html'
      controller: 'SessionsController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'sessions'
        $translate.refresh()
    ]
  return
