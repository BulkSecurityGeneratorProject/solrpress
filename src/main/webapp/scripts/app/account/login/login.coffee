"use strict"
angular.module("solrpressApp").config ($stateProvider) ->
  $stateProvider.state "login",
    parent: "account"
    url: "/login"
    data:
      roles: []

    views:
      "content@":
        templateUrl: "scripts/app/account/login/login.html"
        controller: "LoginController"

    resolve:
      translatePartialLoader: [
        "$translate"
        "$translatePartialLoader"
        ($translate, $translatePartialLoader) ->
          $translatePartialLoader.addPart "login"
          return $translate.refresh()
      ]

  return

