// Generated by CoffeeScript 1.9.0
'use strict';
angular.module('solrpressApp').factory('Activate', function($resource) {
  return $resource('api/activate', {}, {
    'get': {
      method: 'GET',
      params: {},
      isArray: false
    }
  });
});
