'use strict'
angular.module('solrpressApp').factory 'AuthServerProvider', ($http, localStorageService, Base64) ->
  {
    login: (credentials) ->
      data = undefined
      data = 'username=' + credentials.username + '&password=' + credentials.password + '&grant_type=password&scope=read%20write&' + 'client_secret=mySecretOAuthSecret&client_id=SolrPressapp'
      $http.post('oauth/token', data, headers:
        'Content-Type': 'application/x-www-form-urlencoded'
        'Accept': 'application/json'
        'Authorization': 'Basic ' + Base64.encode('SolrPressapp' + ':' + 'mySecretOAuthSecret')).success (response) ->
        expiredAt = undefined
        expiredAt = new Date
        expiredAt.setSeconds expiredAt.getSeconds() + response.expires_in
        response.expires_at = expiredAt.getTime()
        localStorageService.set 'token', response
        response
    logout: ->
      $http.post('api/logout').then ->
        localStorageService.clearAll()
        return
      return
    getToken: ->
      localStorageService.get 'token'
    hasValidToken: ->
      token = undefined
      token = @getToken()
      token and token.expires_at and token.expires_at > (new Date).getTime()

  }
