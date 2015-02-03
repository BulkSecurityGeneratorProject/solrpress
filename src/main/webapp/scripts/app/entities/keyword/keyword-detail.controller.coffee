'use strict'
angular.module('solrpressApp').controller 'KeywordDetailController', ($scope, $stateParams, Keyword) ->
  $scope.keyword = {}

  $scope.load = (id) ->
    Keyword.get { id: id }, (result) ->
      $scope.keyword = result
      return
    return

  $scope.load $stateParams.id
  return
