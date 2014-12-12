"use strict"

# Services
solrpressApp.factory "LanguageService", ($http, $translate, LANGUAGES) ->
    getBy: (language) ->
        language = $translate.storage().get("NG_TRANSLATE_LANG_KEY")  unless language?
        language = "en"  unless language?
        promise = $http.get("i18n/" + language + ".json").then((response) ->
            LANGUAGES
        )
        promise

solrpressApp.factory "Register", ($resource) ->
    $resource "app/rest/register", {}, {}

solrpressApp.factory "Activate", ($resource) ->
    $resource "app/rest/activate", {},
        get:
            method: "GET"
            params: {}
            isArray: false


solrpressApp.factory "Account", ($resource) ->
    $resource "app/rest/account", {}, {}

solrpressApp.factory "Password", ($resource) ->
    $resource "app/rest/account/change_password", {}, {}

solrpressApp.factory "Sessions", ($resource) ->
    $resource "app/rest/account/sessions/:series", {},
        get:
            method: "GET"
            isArray: true


solrpressApp.factory "MetricsService", ($http) ->
    get: ->
        promise = $http.get("metrics/metrics").then((response) ->
            response.data
        )
        promise

solrpressApp.factory "ThreadDumpService", ($http) ->
    dump: ->
        promise = $http.get("dump").then((response) ->
            response.data
        )
        promise

solrpressApp.factory "HealthCheckService", ($rootScope, $http) ->
    check: ->
        promise = $http.get("health").then((response) ->
            response.data
        )
        promise

solrpressApp.factory "ConfigurationService", ($rootScope, $filter, $http) ->
    get: ->
        promise = $http.get("configprops").then((response) ->
            properties = []
            angular.forEach response.data, (data) ->
                properties.push data
                return

            orderBy = $filter("orderBy")
            return orderBy(properties, "prefix")
            return
        )
        promise

solrpressApp.factory "LogsService", ($resource) ->
    $resource "app/rest/logs", {},
        findAll:
            method: "GET"
            isArray: true

        changeLevel:
            method: "PUT"


solrpressApp.factory "AuditsService", ($http) ->
    findAll: ->
        promise = $http.get("app/rest/audits/all").then((response) ->
            response.data
        )
        promise

    findByDates: (fromDate, toDate) ->
        promise = $http.get("app/rest/audits/byDates",
            params:
                fromDate: fromDate
                toDate: toDate
        ).then((response) ->
            response.data
        )
        promise

solrpressApp.factory "Session", ->
    @create = (login, firstName, lastName, email, userRoles) ->
        @login = login
        @firstName = firstName
        @lastName = lastName
        @email = email
        @userRoles = userRoles
        return

    @invalidate = ->
        @login = null
        @firstName = null
        @lastName = null
        @email = null
        @userRoles = null
        return

    this

solrpressApp.factory "AuthenticationSharedService", ($rootScope, $http, authService, Session, Account) ->
    login: (param) ->
        data = "j_username=" + encodeURIComponent(param.username) + "&j_password=" + encodeURIComponent(param.password) + "&_spring_security_remember_me=" + param.rememberMe + "&submit=Login"
        $http.post("app/authentication", data,
            headers:
                "Content-Type": "application/x-www-form-urlencoded"

            ignoreAuthModule: "ignoreAuthModule"
        ).success((data, status, headers, config) ->
            Account.get (data) ->
                Session.create data.login, data.firstName, data.lastName, data.email, data.roles
                $rootScope.account = Session
                authService.loginConfirmed data
                return

            return
        ).error (data, status, headers, config) ->
            $rootScope.authenticationError = true
            Session.invalidate()
            return

        return

    valid: (authorizedRoles) ->

        # user is not allowed

        # user is not allowed
        $http.get("protected/authentication_check.gif",
            ignoreAuthModule: "ignoreAuthModule"
        ).success((data, status, headers, config) ->
            unless Session.login
                Account.get (data) ->
                    Session.create data.login, data.firstName, data.lastName, data.email, data.roles
                    $rootScope.account = Session
                    unless $rootScope.isAuthorized(authorizedRoles)
                        $rootScope.$broadcast "event:auth-notAuthorized"
                    else
                        $rootScope.$broadcast "event:auth-loginConfirmed"
                    return

            else
                unless $rootScope.isAuthorized(authorizedRoles)
                    $rootScope.$broadcast "event:auth-notAuthorized"
                else
                    $rootScope.$broadcast "event:auth-loginConfirmed"
            return
        ).error (data, status, headers, config) ->
            $rootScope.$broadcast "event:auth-loginRequired", data  unless $rootScope.isAuthorized(authorizedRoles)
            return

        return

    isAuthorized: (authorizedRoles) ->
        unless angular.isArray(authorizedRoles)
            return true  if authorizedRoles is "*"
            authorizedRoles = [authorizedRoles]
        isAuthorized = false
        angular.forEach authorizedRoles, (authorizedRole) ->
            authorized = (!!Session.login and Session.userRoles.indexOf(authorizedRole) isnt -1)
            isAuthorized = true  if authorized or authorizedRole is "*"
            return

        isAuthorized

    logout: ->
        $rootScope.authenticationError = false
        $rootScope.authenticated = false
        $rootScope.account = null
        $http.get "app/logout"
        Session.invalidate()
        authService.loginCancelled()
        return

