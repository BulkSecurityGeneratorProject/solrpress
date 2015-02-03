'use strict'
angular.module('solrpressApp').controller 'NavbarController', ($scope, $location, $state, Auth, Principal) ->
  $scope.isAuthenticated = Principal.isAuthenticated
  $scope.isInRole = Principal.isInRole
  $scope.$state = $state

  $scope.logout = ->
    Auth.logout()
    $state.go 'home'
    return

  return
