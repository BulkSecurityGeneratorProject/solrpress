'use strict';
angular.module('solrpressApp').factory('Account', function($resource) {
  return $resource('api/account', {}, {
    'get': {
      method: 'GET',
      params: {},
      isArray: false,
      interceptor: {
        response: function(response) {
          return response;
        }
      }
    }
  });
});
