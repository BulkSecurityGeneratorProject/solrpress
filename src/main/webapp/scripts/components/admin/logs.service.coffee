'use strict'
angular.module('solrpressApp').factory 'LogsService', ($resource) ->
  $resource 'api/logs', {},
    'findAll':
      method: 'GET'
      isArray: true
    'changeLevel': method: 'PUT'
