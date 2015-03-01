'use strict'
angular.module('solrpressApp').factory 'AuthServerProvider', ($http, localStorageService, $window, Tracker) ->
  {
    login: (credentials) ->
      data = 'j_username=' + encodeURIComponent(credentials.username) + '&j_password=' + encodeURIComponent(credentials.password) + '&_spring_security_remember_me=' + credentials.rememberMe + '&submit=Login'
      $http.post('api/authentication', data, headers: 'Content-Type': 'application/x-www-form-urlencoded').success (response) ->
        localStorageService.set 'token', $window.btoa(credentials.username + ':' + credentials.password)
        response
    logout: ->
      Tracker.disconnect()
      # logout from the server
      $http.post('api/logout').success (response) ->
        localStorageService.clearAll()
        # to get a new csrf token call the api
        $http.get 'api/account'
        response
      return
    getToken: ->
      token = localStorageService.get('token')
      token
    hasValidToken: ->
      token = @getToken()
      ! !token

  }
