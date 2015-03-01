'use strict'

angular.module('solrpressApp').controller 'MainController', ($scope, Principal) ->
    Principal.identity().then (account) ->
        $scope.account = account
        $scope.isAuthenticated = Principal.isAuthenticated
        return
    return
