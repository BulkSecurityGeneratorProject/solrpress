angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'tracker',
    parent: 'admin'
    url: '/tracker'
    data: roles: [ 'ROLE_ADMIN' ]
    views: 'content@':
      templateUrl: 'scripts/app/admin/tracker/tracker.html'
      controller: 'TrackerController'
    resolve: mainTranslatePartialLoader: [
      '$translate'
      '$translatePartialLoader'
      ($translate, $translatePartialLoader) ->
        $translatePartialLoader.addPart 'tracker'
        $translate.refresh()
    ]
  return
