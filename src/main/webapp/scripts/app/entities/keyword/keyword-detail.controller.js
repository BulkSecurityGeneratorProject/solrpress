'use strict';

angular.module('solrpressApp')
    .controller('KeywordDetailController', function ($scope, $stateParams, Keyword) {
        $scope.keyword = {};
        $scope.load = function (id) {
            Keyword.get({id: id}, function(result) {
              $scope.keyword = result;
            });
        };
        $scope.load($stateParams.id);
    });
