'use strict';

angular.module('solrpressApp')
    .config(function ($stateProvider) {
        $stateProvider
            .state('keyword', {
                parent: 'entity',
                url: '/keyword',
                data: {
                    roles: ['ROLE_USER']
                },
                views: {
                    'content@': {
                        templateUrl: 'app/entities/keyword/keywords.html',
                        controller: 'KeywordController'
                    }
                }
            });
    })
    .controller('KeywordController', function ($scope, Keyword) {
        $scope.keywords = [];
        $scope.loadAll = function() {
            Keyword.query(function(result) {
               $scope.keywords = result;
            });
        };
        $scope.loadAll();

        $scope.create = function () {
            Keyword.save($scope.keyword,
                function () {
                    $scope.loadAll();
                    $('#saveKeywordModal').modal('hide');
                    $scope.clear();
                });
        };

        $scope.update = function (id) {
            $scope.keyword = Keyword.get({id: id});
            $('#saveKeywordModal').modal('show');
        };

        $scope.delete = function (id) {
            Keyword.delete({id: id}, $scope.loadAll);
        };

        $scope.clear = function () {
            $scope.keyword = {title: null, description: null, created: null, update: null, status: null, id: null};
        };
    });
