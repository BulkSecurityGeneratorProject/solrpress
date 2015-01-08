"use strict";

angular.module("solrpressApp")
    .controller("AuthorController", function ($scope, Author) {
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
                    $("#saveAuthorModal").modal("hide");
                    $scope.clear();
                });
        };

        $scope.update = function (id) {
            $scope.author = Author.get({id: id});
            $("#saveAuthorModal").modal("show");
        };

        $scope.delete = function (id) {
            $scope.author = Author.get({id: id});
            $("#deleteAuthorConfirmation").modal("show");
        };

        $scope.confirmDelete = function (id) {
            Author.delete({id: id},
                function () {
                    $scope.loadAll();
                    $("#deleteAuthorConfirmation").modal("hide");
                    $scope.clear();
                });
        };

        $scope.clear = function () {
            $scope.author = {name: null, birthDate: null, gender: null, id: null};
        };
    });
