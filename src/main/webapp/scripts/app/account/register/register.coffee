"use strict"
angular.module("solrpressApp").config ($stateProvider) ->
  $stateProvider.state "register",
    parent: "account"
    url: "/register"
    data:
      roles: []

    views:
      "content@":
        templateUrl: "scripts/app/account/register/register.html"
        controller: "RegisterController"

    resolve:
      translatePartialLoader: [
        "$translate"
        "$translatePartialLoader"
        ($translate, $translatePartialLoader) ->
          $translatePartialLoader.addPart "register"
          return $translate.refresh()
      ]

  return

