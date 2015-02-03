'use strict';
angular.module('solrpressApp').controller('KeywordController', function($scope, Keyword) {
  $scope.keywords = [];
  $scope.loadAll = function() {
    Keyword.query(function(result) {
      $scope.keywords = result;
    });
    $.flash({
      content: 'all keywords has been loaded',
      style: 'right',
      timeout: 3000
    });
  };
  $scope.loadAll();
  $scope.create = function() {
    Keyword.save($scope.keyword, function() {
      $.flash({
        content: 'keyword has been updated',
        style: 'right',
        timeout: 5000
      });
      $scope.loadAll();
      $('#saveKeywordModal').modal('hide');
      $scope.clear();
    });
  };
  $scope.update = function(id) {
    $scope.keyword = Keyword.get({
      id: id
    });
    $('#saveKeywordModal').modal('show');
  };
  $scope['delete'] = function(id) {
    return $scope.keyword = Keyword.get({
      id: id
    }).then(function() {
      return $('#deleteKeywordConfirmation').modal('show');
    });
  };
  $scope.confirmDelete = function(id) {
    return Keyword['delete']({
      id: id
    }).then(function() {
      $scope.loadAll();
      $('#deleteKeywordConfirmation').modal('hide');
      return $scope.clear();
    });
  };
  $scope.clear = function() {
    $scope.keyword = {
      label: null,
      score: null,
      network: null,
      timestamp: null,
      info: null,
      id: null
    };
  };
});
