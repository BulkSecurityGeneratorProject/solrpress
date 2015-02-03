'use strict';
angular.module('solrpressApp').factory('AuditsService', function($http) {
  return {
    findAll: function() {
      return $http.get('api/audits/all').then(function(response) {
        return response.data;
      });
    },
    findByDates: function(fromDate, toDate) {
      var formatDate;
      formatDate = void 0;
      formatDate = function(dateToFormat) {
        if (dateToFormat !== void 0 && !angular.isString(dateToFormat)) {
          return dateToFormat.getYear() + '-' + dateToFormat.getMonth() + '-' + dateToFormat.getDay();
        }
        return dateToFormat;
      };
      return $http.get('api/audits/byDates', {
        params: {
          fromDate: formatDate(fromDate),
          toDate: formatDate(toDate)
        }
      }).then(function(response) {
        return response.data;
      });
    }
  };
});
