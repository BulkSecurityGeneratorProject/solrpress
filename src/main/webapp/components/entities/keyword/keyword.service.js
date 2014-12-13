'use strict';

angular.module('solrpressApp')
    .factory('Keyword', function ($resource) {
        return $resource('api/keywords/:id', {}, {
            'query': { method: 'GET', isArray: true},
            'get': {
                method: 'GET',
                transformResponse: function (data) {
                    data = angular.fromJson(data);
                    var createdFrom = data.created.split("-");
                    data.created = new Date(new Date(createdFrom[0], createdFrom[1] - 1, createdFrom[2]));
                    var updateFrom = data.update.split("-");
                    data.update = new Date(new Date(updateFrom[0], updateFrom[1] - 1, updateFrom[2]));
                    return data;
                }
            }
        });
    });
