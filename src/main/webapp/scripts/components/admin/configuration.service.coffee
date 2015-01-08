"use strict"

angular.module("solrpressApp").factory "ConfigurationService", ($rootScope, $filter, $http) ->
    get: ->
        $http.get("configprops").then (response) ->
            properties = []
            angular.forEach response.data, (data) ->
                properties.push data
                return

            orderBy = $filter("orderBy")
            orderBy properties, "prefix"


