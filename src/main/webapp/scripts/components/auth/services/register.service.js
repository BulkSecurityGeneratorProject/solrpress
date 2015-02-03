'use strict';
angular.module('solrpressApp').factory('Register', function($resource) {
  return $resource('api/register', {}, {});
});
