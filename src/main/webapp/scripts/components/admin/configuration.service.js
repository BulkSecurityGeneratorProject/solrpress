'use strict';
angular.module('solrpressApp').factory('ConfigurationService', function($rootScope, $filter, $http) {
  return {
    get: function() {
      return $http.get('configprops').then(function(response) {
        var orderBy, properties;
        orderBy = void 0;
        properties = void 0;
        properties = [];
        angular.forEach(response.data, function(data) {
          properties.push(data);
        });
        orderBy = $filter('orderBy');
        return orderBy(properties, 'prefix');
      });
    }
  };
});
