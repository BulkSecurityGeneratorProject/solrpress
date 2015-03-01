'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'register',
    parent: 'account'
    url: '/register'
    data:
      roles: []
      pageTitle: 'register.title'
    views: 'content@':
      templateUrl: 'scripts/app/account/register/register.html'
      controller: 'RegisterController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'register'
        $translate.refresh()
    ]
  return
