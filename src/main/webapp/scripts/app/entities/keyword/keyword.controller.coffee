'use strict'
angular.module('solrpressApp').controller 'KeywordController', ($scope, Keyword) ->
  $scope.keywords = []

  $scope.loadAll = ->
    Keyword.query (result) ->
      $scope.keywords = result
      return
    return

  $scope.loadAll()

  $scope.create = ->
    Keyword.save $scope.keyword, ->
      $scope.loadAll()
      $('#saveKeywordModal').modal 'hide'
      $scope.clear()
      return
    return

  $scope.update = (id) ->
    Keyword.get { id: id }, (result) ->
      $scope.keyword = result
      $('#saveKeywordModal').modal 'show'
      return
    return

  $scope.delete = (id) ->
    Keyword.get { id: id }, (result) ->
      $scope.keyword = result
      $('#deleteKeywordConfirmation').modal 'show'
      return
    return

  $scope.confirmDelete = (id) ->
    Keyword.delete { id: id }, ->
      $scope.loadAll()
      $('#deleteKeywordConfirmation').modal 'hide'
      $scope.clear()
      return
    return

  $scope.clear = ->
    $scope.keyword =
      label: null
      score: null
      network: null
      timestamp: null
      info: null
      id: null
    return

  return
