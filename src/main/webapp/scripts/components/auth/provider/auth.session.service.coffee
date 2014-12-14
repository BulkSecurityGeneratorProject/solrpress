'use strict'

loginService = undefined

angular.module('solrpressApp').factory 'AuthServerProvider', loginService = ($http, localStorageService) ->
    login: (credentials) ->
        data = undefined
        data = 'j_username=' + encodeURIComponent(credentials.username) + '&j_password=' + encodeURIComponent(credentials.password) + '&_spring_security_remember_me=' + credentials.rememberMe + '&submit=Login'
        $http.post('api/authentication', data,
            headers:
                'Content-Type': 'application/x-www-form-urlencoded'
        ).success (response) ->
            localStorageService.set 'token', btoa(credentials.username + ':' + credentials.password)
            response


    logout: ->
        localStorageService.clearAll()
        $http.post 'api/logout'
        return

    getToken: ->
        token = undefined
        token = localStorageService.get('token')
        token

    hasValidToken: ->
        token = undefined
        token = @getToken()
        !!token

