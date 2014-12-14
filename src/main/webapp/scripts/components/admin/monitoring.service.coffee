'use strict'

angular.module('solrpressApp').factory 'MonitoringService', ($rootScope, $http) ->
    getMetrics: ->
        $http.get('metrics/metrics').then (response) ->
            response.data


    checkHealth: ->
        $http.get('health').then (response) ->
            response.data


    threadDump: ->
        $http.get('dump').then (response) ->
            response.data

