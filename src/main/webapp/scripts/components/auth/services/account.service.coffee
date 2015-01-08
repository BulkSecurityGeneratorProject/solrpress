"use strict"

angular.module("solrpressApp").factory "Account", Account = ($resource) ->
    $resource "api/account", {},
        get:
            method: "GET"
            params: {}
            isArray: false
            interceptor:
                response: (response) ->

                    # expose response
                    response


