'use strict'
angular.module('solrpressApp').factory 'Keyword', ($resource) ->
  $resource 'api/keywords/:id', {},
    'query':
      method: 'GET'
      isArray: true
    'get':
      method: 'GET'
      transformResponse: (data) ->
        data = angular.fromJson(data)
        timestampFrom = data.timestamp.split('-')
        data.timestamp = new Date(new Date(timestampFrom[0], timestampFrom[1] - 1, timestampFrom[2]))
        data
