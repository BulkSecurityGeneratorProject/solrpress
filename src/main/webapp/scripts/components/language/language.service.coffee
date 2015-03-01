'use strict'
angular.module('solrpressApp').factory('Language', ($q, $http, $translate, LANGUAGES) ->
  {
    getCurrent: ->
      deferred = $q.defer()
      language = $translate.storage().get('NG_TRANSLATE_LANG_KEY')
      if angular.isUndefined(language)
        language = 'en'
      deferred.resolve language
      deferred.promise
    getAll: ->
      deferred = $q.defer()
      deferred.resolve LANGUAGES
      deferred.promise

  }
).constant 'LANGUAGES', [
  'en'
  'fr'
]
