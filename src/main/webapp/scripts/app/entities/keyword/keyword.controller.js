'use strict';

angular.module('solrpressApp')
    .controller('KeywordController', function ($scope, Keyword) {
        $scope.keywords = [];
        $scope.loadAll = function() {
            Keyword.query(function(result) {
               $scope.keywords = result;
            });
        };
        $scope.loadAll();

        $scope.create = function () {
            Keyword.update($scope.keyword,
                function () {
                    $scope.loadAll();
                    $('#saveKeywordModal').modal('hide');
                    $scope.clear();
                });
        };

        $scope.update = function (id) {
            Keyword.get({id: id}, function(result) {
                $scope.keyword = result;
                $('#saveKeywordModal').modal('show');
            });
        };

        $scope.delete = function (id) {
            Keyword.get({id: id}, function(result) {
                $scope.keyword = result;
                $('#deleteKeywordConfirmation').modal('show');
            });
        };

        $scope.confirmDelete = function (id) {
            Keyword.delete({id: id},
                function () {
                    $scope.loadAll();
                    $('#deleteKeywordConfirmation').modal('hide');
                    $scope.clear();
                });
        };

        $scope.clear = function () {
            $scope.keyword = {label: null, keyword: null, score: null, network: null, timestamp: null, info: null, id: null};
        };
    });
