'use strict'
angular.module('solrpressApp').controller 'RegisterController', ($scope, $translate, $timeout, Auth) ->
  $scope.success = null
  $scope.error = null
  $scope.doNotMatch = null
  $scope.errorUserExists = null
  $scope.registerAccount = {}
  $timeout ->
    angular.element('[ng-model="registerAccount.login"]').focus()
    return

  $scope.register = ->
    if $scope.registerAccount.password != $scope.confirmPassword
      $scope.doNotMatch = 'ERROR'
    else
      $scope.registerAccount.langKey = $translate.use()
      $scope.doNotMatch = null
      $scope.error = null
      $scope.errorUserExists = null
      $scope.errorEmailExists = null
      Auth.createAccount($scope.registerAccount).then(->
        $scope.success = 'OK'
        return
      ).catch (response) ->
        $scope.success = null
        if response.status == 400 and response.data == 'login already in use'
          $scope.errorUserExists = 'ERROR'
        else if response.status == 400 and response.data == 'e-mail address already in use'
          $scope.errorEmailExists = 'ERROR'
        else
          $scope.error = 'ERROR'
        return
    return

  return
