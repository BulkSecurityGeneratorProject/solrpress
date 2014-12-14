'use strict'

angular.module('solrpressApp').controller 'LanguageController', ($scope, $translate, Language) ->
    $scope.changeLanguage = (languageKey) ->
        $translate.use languageKey
        Language.getBy(languageKey).then (languages) ->
            $scope.languages = languages
            return

        return

    Language.getBy().then (languages) ->
        $scope.languages = languages
        return

    return

