"use strict"

#
# Languages codes are ISO_639-1 codes, see http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
# They are written in English to avoid character encoding issues (not a perfect solution)
#
angular.module("solrpressApp").factory("Language", ($q, $http, $translate, LANGUAGES) ->
    getCurrent: ->
        deferred = $q.defer()
        language = $translate.storage().get("NG_TRANSLATE_LANG_KEY")
        language = "en"  if angular.isUndefined(language)
        deferred.resolve language
        deferred.promise

    getAll: ->
        deferred = $q.defer()
        deferred.resolve LANGUAGES
        deferred.promise
).constant "LANGUAGES", [
    "en"
    "fr"
]

#JHipster will add new languages here
