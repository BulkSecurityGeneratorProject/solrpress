'use strict';
angular.module('solrpressApp').controller('LogoutController', function(Auth) {
  Auth.logout();
});
