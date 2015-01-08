"use strict"
angular.module("solrpressApp").factory "Activate", ($resource) ->
    $resource "api/activate", {},
        get:
            method: "GET"
            params: {}
            isArray: false


