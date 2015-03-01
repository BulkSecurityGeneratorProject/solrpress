'use strict'
angular.module('solrpressApp').factory 'User', ($resource) ->
  $resource 'api/users/:login', {},
    'query':
      method: 'GET'
      isArray: true
    'get':
      method: 'GET'
      transformResponse: (data) ->
        data = angular.fromJson(data)
        data
