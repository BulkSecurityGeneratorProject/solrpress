"use strict"

angular.module("solrpressApp").controller "ConfigurationController", ($scope, ConfigurationService) ->
    ConfigurationService.get().then (configuration) ->
        $scope.configuration = configuration
        return

    return

