# Generated by CoffeeScript 1.9.0
'use strict'
angular.module('solrpressApp').controller 'AuthorDetailController', ($scope, $stateParams, Author) ->
  $scope.author = {}

  $scope.load = (id) ->
    Author.get { id: id }, (result) ->
      $scope.author = result
      return
    return

  $scope.load $stateParams.id
  return