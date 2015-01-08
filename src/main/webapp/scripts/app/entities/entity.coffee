"use strict"

angular.module("solrpressApp").config ($stateProvider) ->
    $stateProvider.state "entity",
        abstract: true
        parent: "site"

    return

