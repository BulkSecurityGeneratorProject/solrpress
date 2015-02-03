'use strict';
angular.module('solrpressApp').factory('Language', function($q, $http, $translate, LANGUAGES) {
  return {
    getCurrent: function() {
      var deferred, language;
      deferred = $q.defer();
      language = $translate.storage().get('NG_TRANSLATE_LANG_KEY');
      if (angular.isUndefined(language)) {
        language = 'en';
      }
      deferred.resolve(language);
      return deferred.promise;
    },
    getAll: function() {
      var deferred;
      deferred = $q.defer();
      deferred.resolve(LANGUAGES);
      return deferred.promise;
    }
  };
}).constant('LANGUAGES', ['en', 'fr']);
