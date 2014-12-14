'use strict'
angular.module('solrpressApp').factory 'Sessions', ($resource) ->
    $resource 'api/account/sessions/:series', {},
        getAll:
            method: 'GET'
            isArray: true


