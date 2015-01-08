"use strict"

angular.module("solrpressApp")

.config ($stateProvider, USER_ROLES) ->
  $stateProvider.state "home",
    parent: "site"
    url: "/"
    data:
      roles: [USER_ROLES.all]

    views:
      "content@":
        templateUrl: "scripts/app/main/main.html"
        controller: "MainController"

    resolve:
      mainTranslatePartialLoader: [
        "$translate"
        "$translatePartialLoader"
        ($translate, $translatePartialLoader) ->
          $translatePartialLoader.addPart "main"
          return $translate.refresh()
      ]

  return
