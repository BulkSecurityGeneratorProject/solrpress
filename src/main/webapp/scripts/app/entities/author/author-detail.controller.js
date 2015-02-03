'use strict';
angular.module('solrpressApp').controller('AuthorDetailController', function($scope, $stateParams, Author) {
  $scope.author = {};
  $scope.load = function(id) {
    Author.get({
      id: id
    }, function(result) {
      $scope.author = result;
    });
  };
  $scope.load($stateParams.id);
});