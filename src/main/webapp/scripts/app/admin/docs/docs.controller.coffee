'use strict'

angular.module('solrpressApp').config ($stateProvider) ->
    $stateProvider.state 'docs',
        parent: 'admin'
        url: '/docs'
        data:
            roles: ['ROLE_ADMIN']

        views:
            'content@':
                templateUrl: 'scripts/app/admin/docs/docs.html'

    return
