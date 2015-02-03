'use strict'

angular.module('solrpressApp').controller 'LanguageController', ($scope, $translate, Language) ->
    $scope.changeLanguage = (languageKey) ->
        $translate.use languageKey
        return

    Language.getAll().then (languages) ->
        $scope.languages = languages
        return
    return
