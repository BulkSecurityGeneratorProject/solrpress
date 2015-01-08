"use strict"

angular.module("solrpressApp").config ($stateProvider) ->
    $stateProvider.state("author",
        parent: "entity"
        url: "/author"
        data:
            roles: ["ROLE_USER"]

        views:
            "content@":
                templateUrl: "scripts/app/entities/author/authors.html"
                controller: "AuthorController"

        resolve:
            translatePartialLoader: [
                "$translate"
                "$translatePartialLoader"
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart "author"
                    return $translate.refresh()
            ]
    ).state "authorDetail",
        parent: "entity"
        url: "/author/:id"
        data:
            roles: ["ROLE_USER"]

        views:
            "content@":
                templateUrl: "scripts/app/entities/author/author-detail.html"
                controller: "AuthorDetailController"

        resolve:
            translatePartialLoader: [
                "$translate"
                "$translatePartialLoader"
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart "author"
                    return $translate.refresh()
            ]

    return

