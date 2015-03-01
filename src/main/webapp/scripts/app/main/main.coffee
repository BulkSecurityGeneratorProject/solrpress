'use strict'

angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'home',
    parent: 'site'
    url: '/'
    data: roles: []
    views: 'content@':
      templateUrl: 'scripts/app/main/main.html'
      controller: 'MainController'
    resolve: mainTranslatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'main'
        $translate.refresh()
    ]
  return
