'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'password',
    parent: 'account'
    url: '/password'
    data:
      roles: [ 'ROLE_USER' ]
      pageTitle: 'global.menu.account.password'
    views: 'content@':
      templateUrl: 'scripts/app/account/password/password.html'
      controller: 'PasswordController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'password'
        $translate.refresh()
    ]
  return
