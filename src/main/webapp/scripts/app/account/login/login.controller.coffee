'use strict'
angular.module('solrpressApp').controller 'LoginController', ($rootScope, $scope, $state, $timeout, Auth) ->
  $scope.user = {}
  $scope.errors = {}
  $scope.rememberMe = true
  $timeout ->
    angular.element('[ng-model="username"]').focus()
    return

  $scope.login = ->
    Auth.login(
      username: $scope.username
      password: $scope.password
      rememberMe: $scope.rememberMe).then(->
      $scope.authenticationError = false
      $rootScope.back()
      return
    )['catch'] ->
      $scope.authenticationError = true
      return
    return

  return
