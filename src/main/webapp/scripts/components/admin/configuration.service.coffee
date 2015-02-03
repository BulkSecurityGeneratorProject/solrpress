'use strict'
angular.module('solrpressApp').factory 'ConfigurationService', ($rootScope, $filter, $http) ->
  { get: ->
    $http.get('configprops').then (response) ->
      orderBy = undefined
      properties = undefined
      orderBy = undefined
      properties = undefined
      properties = []
      angular.forEach response.data, (data) ->
        properties.push data
        return
      orderBy = $filter('orderBy')
      orderBy properties, 'prefix'
 }
