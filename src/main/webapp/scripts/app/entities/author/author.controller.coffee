"use strict"
angular.module("solrpressApp").controller "AuthorController", ($scope, Author) ->

    $scope.authors = []

    $scope.loadAll = ->
        Author.query (result) ->
            $scope.authors = result
            return

        return

    $scope.loadAll()
    $scope.create = ->
        Author.save $scope.author, ->
            $scope.loadAll()
            $("#saveAuthorModal").modal "hide"
            $scope.clear()
            return

        return

    $scope.update = (id) ->
        $scope.author = Author.get(id: id)
        $("#saveAuthorModal").modal "show"
        return


    $scope.delete = () ->
        $scope.author = Author.get
            id: id
        $("#deleteAuthorConfirmation").modal("show")


    $scope.confirmDelete = (id) ->
        Author.delete
            id: id
        .then ->
            $scope.loadAll()
            $("#deleteAuthorConfirmation").modal("hide")
            $scope.clear()

    $scope.clear = ->
        $scope.author =
            name: null
            birthDate: null
            gender: null
            id: null

        return

    return
