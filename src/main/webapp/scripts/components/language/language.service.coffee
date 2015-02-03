'use strict'
angular.module('solrpressApp').factory('Language', ($q, $http, $translate, LANGUAGES) ->
    {
    getCurrent: ->
        deferred = undefined
        language = undefined
        deferred = $q.defer()
        language = $translate.storage().get('NG_TRANSLATE_LANG_KEY')
        if angular.isUndefined(language)
            language = 'en'
        deferred.resolve language
        deferred.promise
    getAll: ->
        deferred = undefined
        deferred = $q.defer()
        deferred.resolve LANGUAGES
        deferred.promise

    }
).constant 'LANGUAGES', [
    'bn'
    'en'
    'fr'
    'de'
    'es'
]
