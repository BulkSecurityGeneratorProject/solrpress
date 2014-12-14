'use strict'

angular.module('solrpressApp').factory 'Register', ($resource) ->
    $resource 'api/register', {}, {}
