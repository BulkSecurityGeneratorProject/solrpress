#global angular:true, browser:true

###*
@license HTTP Auth Interceptor Module for AngularJS
(c) 2012 Witold Szczerba
License: MIT
###
(->
    "use strict"

    ###*
    Call this function to indicate that authentication was successfull and trigger a
    retry of all deferred requests.
    @param data an optional argument to pass on to $broadcast which may be useful for
    example if you need to pass through details of the user that was logged in
    ###

    ###*
    Call this function to indicate that authentication should not proceed.
    All deferred requests will be abandoned or rejected (if reason is provided).
    @param data an optional argument to pass on to $broadcast.
    @param reason if provided, the requests are rejected; abandoned otherwise.
    ###

    ###*
    $http interceptor.
    On 401 response (without 'ignoreAuthModule' option) stores the request
    and broadcasts 'event:auth-loginRequired'.
    ###
    angular.module("http-auth-interceptor", ["http-auth-interceptor-buffer"]).factory("authService",
    ($rootScope, httpBuffer) ->
        loginConfirmed: (data, configUpdater) ->
            updater = configUpdater or (config) ->
                config

            $rootScope.$broadcast "event:auth-loginConfirmed", data
            httpBuffer.retryAll updater
            return

        loginCancelled: (data, reason) ->
            httpBuffer.rejectAll reason
            $rootScope.$broadcast "event:auth-loginCancelled", data
            return
    ).config ($httpProvider) ->
        interceptor = [
            "$rootScope"
            "$q"
            "httpBuffer"
            ($rootScope, $q, httpBuffer) ->
                success = (response) ->
                    response
                error = (response) ->
                    if response.status is 401 and not response.config.ignoreAuthModule
                        deferred = $q.defer()
                        httpBuffer.append response.config, deferred
                        $rootScope.$broadcast "event:auth-loginRequired", response
                        return deferred.promise
                    else $rootScope.$broadcast "event:auth-notAuthorized", response  if response.status is 403 and not response.config.ignoreAuthModule

                    # otherwise, default behaviour
                    $q.reject response
                return (promise) ->
                    promise.then success, error
        ]
        $httpProvider.interceptors.push interceptor
        return


    ###*
    Private module, a utility, required internally by 'http-auth-interceptor'.
    ###
    angular.module("http-auth-interceptor-buffer", []).factory "httpBuffer", ($injector) ->

        ###*
        Holds all the requests, so they can be re-requested in future.
        ###

        ###*
        Service initialized later because of circular dependency problem.
        ###
        retryHttpRequest = (config, deferred) ->
            successCallback = (response) ->
                deferred.resolve response
                return
            errorCallback = (response) ->
                deferred.reject response
                return
            $http = $http or $injector.get("$http")
            $http(config).then successCallback, errorCallback
            return
        buffer = []
        $http = undefined

        ###*
        Appends HTTP request configuration object with deferred response attached to buffer.
        ###
        append: (config, deferred) ->
            buffer.push
                config: config
                deferred: deferred

            return


        ###*
        Abandon or reject (if reason provided) all the buffered requests.
        ###
        rejectAll: (reason) ->
            if reason
                i = 0

                while i < buffer.length
                    buffer[i].deferred.reject reason
                    ++i
            buffer = []
            return


        ###*
        Retries all the buffered requests clears the buffer.
        ###
        retryAll: (updater) ->
            i = 0

            while i < buffer.length
                retryHttpRequest updater(buffer[i].config), buffer[i].deferred
                ++i
            buffer = []
            return

    return)()
