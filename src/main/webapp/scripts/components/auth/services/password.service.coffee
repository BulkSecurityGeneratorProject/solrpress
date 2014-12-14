'use strict'

angular.module('solrpressApp').factory 'Password', ($resource) ->
    $resource 'api/account/change_password', {}, {}

