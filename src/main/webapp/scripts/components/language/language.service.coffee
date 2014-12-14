'use strict'

angular.module('solrpressApp').factory('Language', ($q, $http, $translate, LANGUAGES) ->
    self = undefined
    self = this
    getCurrent: ->
        deferred = undefined
        language = undefined
        deferred = $q.defer()
        language = $translate.storage().get('NG_TRANSLATE_LANG_KEY')
        language = 'en'  unless language?
        deferred.resolve language
        deferred.promise

    getBy: (language) ->
        deferred = undefined
        deferred = $q.defer()
        deferred.resolve LANGUAGES
        deferred.promise
).constant 'LANGUAGES', [
    'en'
    'fr'
]
