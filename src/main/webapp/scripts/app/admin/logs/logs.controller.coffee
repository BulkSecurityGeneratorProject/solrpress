"use strict"

angular.module("solrpressApp").controller "LogsController", ($scope, LogsService) ->
    $scope.loggers = LogsService.findAll()

    $scope.changeLevel = (name, level) ->
        LogsService.changeLevel
            name: name
            level: level
        .then ->
            $scope.loggers = LogsService.findAll()
