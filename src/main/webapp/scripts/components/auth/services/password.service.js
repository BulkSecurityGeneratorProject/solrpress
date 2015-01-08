'use strict';

angular.module('solrpressApp')
	.factory('Password', function ($resource) {
		return $resource('api/account/change_password', {}, {
		});
	});
