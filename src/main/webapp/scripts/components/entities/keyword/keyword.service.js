'use strict';

angular.module('solrpressApp')
    .factory('Keyword', function ($resource) {
        return $resource('api/keywords/:id', {}, {
            'query': { method: 'GET', isArray: true},
            'get': {
                method: 'GET',
                transformResponse: function (data) {
                    data = angular.fromJson(data);
                    var timestampFrom = data.timestamp.split("-");
                    data.timestamp = new Date(new Date(timestampFrom[0], timestampFrom[1] - 1, timestampFrom[2]));
                    return data;
                }
            },
            'update': { method:'PUT' }
        });
    });
