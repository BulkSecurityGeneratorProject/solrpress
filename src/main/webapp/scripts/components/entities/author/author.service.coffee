"use strict"

angular.module("solrpressApp").factory "Author", ($resource) ->
    $resource "api/authors/:id", {},
        query:
            method: "GET"
            isArray: true

        get:
            method: "GET"
            transformResponse: (data) ->
                data = angular.fromJson(data)
                birthDateFrom = data.birthDate.split("-")
                data.birthDate = new Date(new Date(birthDateFrom[0], birthDateFrom[1] - 1, birthDateFrom[2]))
                data


