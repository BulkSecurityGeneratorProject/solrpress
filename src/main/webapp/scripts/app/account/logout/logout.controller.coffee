'use strict'
angular.module('solrpressApp').controller 'LogoutController', (Auth) ->
  Auth.logout()
  return
