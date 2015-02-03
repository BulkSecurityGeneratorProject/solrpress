'use strict';

angular.module('solrpressApp')
    .controller('AuthorController', function ($scope, Author) {
        $scope.authors = [];
        $scope.loadAll = function() {
            Author.query(function(result) {
               $scope.authors = result;
            });
        };
        $scope.loadAll();

        $scope.create = function () {
            Author.save($scope.author,
                function () {
                    $scope.loadAll();
                    $('#saveAuthorModal').modal('hide');
                    $scope.clear();
                });
        };

        $scope.update = function (id) {
            Author.get({id: id}, function(result) {
                $scope.author = result;
                $('#saveAuthorModal').modal('show');
            });
        };

        $scope.delete = function (id) {
            Author.get({id: id}, function(result) {
                $scope.author = result;
                $('#deleteAuthorConfirmation').modal('show');
            });
        };

        $scope.confirmDelete = function (id) {
            Author.delete({id: id},
                function () {
                    $scope.loadAll();
                    $('#deleteAuthorConfirmation').modal('hide');
                    $scope.clear();
                });
        };

        $scope.clear = function () {
            $scope.author = {name: null, birthDate: null, gender: null, id: null};
        };
    });
