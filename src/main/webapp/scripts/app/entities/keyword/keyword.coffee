'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state('keyword',
    parent: 'entity'
    url: '/keyword'
    data: roles: [ 'ROLE_USER' ]
    views: 'content@':
      templateUrl: 'scripts/app/entities/keyword/keywords.html'
      controller: 'KeywordController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'keyword'
        $translate.refresh()
    ]).state 'keywordDetail',
    parent: 'entity'
    url: '/keyword/:id'
    data: roles: [ 'ROLE_USER' ]
    views: 'content@':
      templateUrl: 'scripts/app/entities/keyword/keyword-detail.html'
      controller: 'KeywordDetailController'
    resolve: translatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'keyword'
        $translate.refresh()
    ]
  return
