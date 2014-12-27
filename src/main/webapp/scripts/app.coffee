"use strict"

# App Module
solrpressApp = angular.module("solrpressApp", [
    'ngTouch'
    'ngCookies'
    'ngAria'
    'ngSanitize'
    'ui.router'
    'ngResource'
    'LocalStorageModule'
    'tmh.dynamicLocale'
    'pascalprecht.translate'
    'ui.grid'
    'ui.grid.paging'
    'ui.grid.resizeColumns'
    'ui.grid.pinning'
    'ui.grid.selection'
    'ui.grid.moveColumns'
    'ui.utils'
    'ui.bootstrap'
    'angularMoment'
    'angularFileUpload'
    'ngCacheBuster'
])


solrpressApp.config(($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider, $translateProvider, tmhDynamicLocaleProvider, httpRequestInterceptorCacheBusterProvider, USER_ROLES) ->
    #Cache everything except rest api requests
    httpRequestInterceptorCacheBusterProvider.setMatchlist [/.*rest.*/], true

    $.material.init()
#    $locationProvider.html5Mode(false).hashPrefix('!')
    $translateProvider.preferredLanguage 'en'

    $httpProvider.defaults.xsrfCookieName = 'XSRF-TOKEN'
    $httpProvider.defaults.xsrfHeaderName = 'X-XSRF-TOKEN'
    $httpProvider.defaults.withCredentials = false

    defaultHeaders =
        'Content-Type': 'application/json'
        'Accept-Language': 'en'
        'X-Requested-With': 'XMLHttpRequest'


    $httpProvider.defaults.headers.delete = defaultHeaders
    $httpProvider.defaults.headers.patch = defaultHeaders
    $httpProvider.defaults.headers.post = defaultHeaders
    $httpProvider.defaults.headers.put = defaultHeaders
    $httpProvider.defaults.headers.get = defaultHeaders

    $urlRouterProvider.otherwise '/'

    $stateProvider.state("/register",
        templateUrl: "views/register.html"
        controller: "RegisterController"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).state("/activate",
        templateUrl: "views/activate.html"
        controller: "ActivationController"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).state("/login",
        templateUrl: "views/login.html"
        controller: "LoginController"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).state("/error",
        templateUrl: "views/error.html"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).state("/settings",
        templateUrl: "views/settings.html"
        controller: "SettingsController"
        access:
            authorizedRoles: [USER_ROLES.user]
    ).state("/password",
        templateUrl: "views/password.html"
        controller: "PasswordController"
        access:
            authorizedRoles: [USER_ROLES.user]
    ).state("/sessions",
        templateUrl: "views/sessions.html"
        controller: "SessionsController"
        resolve:
            resolvedSessions: [
                "Sessions"
                (Sessions) ->
                    return Sessions.get()
            ]

        access:
            authorizedRoles: [USER_ROLES.user]
    ).state("/tracker",
        templateUrl: "views/tracker.html"
        controller: "TrackerController"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).state("/metrics",
        templateUrl: "views/metrics.html"
        controller: "MetricsController"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).state("/health",
        templateUrl: "views/health.html"
        controller: "HealthController"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).state("/configuration",
        templateUrl: "views/configuration.html"
        controller: "ConfigurationController"
        resolve:
            resolvedConfiguration: [
                "ConfigurationService"
                (ConfigurationService) ->
                    return ConfigurationService.get()
            ]

        access:
            authorizedRoles: [USER_ROLES.admin]
    ).state("/logs",
        templateUrl: "views/logs.html"
        controller: "LogsController"
        resolve:
            resolvedLogs: [
                "LogsService"
                (LogsService) ->
                    return LogsService.findAll()
            ]

        access:
            authorizedRoles: [USER_ROLES.admin]
    ).state("/audits",
        templateUrl: "views/audits.html"
        controller: "AuditsController"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).state("/logout",
        templateUrl: "views/main.html"
        controller: "LogoutController"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).state("/docs",
        templateUrl: "views/docs.html"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).state("/home",
        templateUrl: "views/main.html"
        controller: "MainController"
        access:
            authorizedRoles: [USER_ROLES.all]
    )

    # Initialize angular-translate
    $translateProvider.useStaticFilesLoader
        prefix: "i18n/"
        suffix: ".json"

    $translateProvider.preferredLanguage "en"
    $translateProvider.useCookieStorage()
    tmhDynamicLocaleProvider.localeLocationPattern "bower_components/angular-i18n/angular-locale_{{locale}}.js"
    tmhDynamicLocaleProvider.useCookieStorage "NG_TRANSLATE_LANG_KEY"
    return
).run(($rootScope, $location, $http, AuthenticationSharedService, Session, USER_ROLES) ->
    $rootScope.authenticated = false
    $rootScope.$on "$stateChangeStart", (event, next) ->
        $rootScope.isAuthorized = AuthenticationSharedService.isAuthorized
        $rootScope.userRoles = USER_ROLES
        AuthenticationSharedService.valid next.access.authorizedRoles
        return

    # Call when the the client is confirmed
    $rootScope.$on "event:auth-loginConfirmed", (data) ->
        $rootScope.authenticated = true
        if $location.path() is "/login"
            search = $location.search()
            if search.redirect isnt `undefined`
                $location.path(search.redirect).search("redirect", null).replace()
            else
                $location.path("/").replace()
        return

    # Call when the 401 response is returned by the server
    $rootScope.$on "event:auth-loginRequired", (rejection) ->
        Session.invalidate()
        $rootScope.authenticated = false
        if $location.path() isnt "/" and $location.path() isnt "" and $location.path() isnt "/register" and $location.path() isnt "/activate" and $location.path() isnt "/login"
            redirect = $location.path()
            $location.path("/login").search("redirect", redirect).replace()
        return

    # Call when the 403 response is returned by the server
    $rootScope.$on "event:auth-notAuthorized", (rejection) ->
        $rootScope.errorMessage = "errors.403"
        $location.path("/error").replace()
        return

    # Call when the user logs out
    $rootScope.$on "event:auth-loginCancelled", ->
        $location.path ""
        return

    return
).run ($rootScope, $state) ->
    # This uses the Atmoshpere framework to do a Websocket connection with the server, in order to send
    # user activities each time a route changes.
    # The user activities can then be monitored by an administrator, see the views/tracker.html Angular view.
    $rootScope.websocketSocket = atmosphere
    $rootScope.websocketSubSocket
    $rootScope.websocketTransport = "websocket"
    $rootScope.websocketRequest =
        url: "websocket/activity"
        contentType: "application/json"
        transport: $rootScope.websocketTransport
        trackMessageLength: true
        reconnectInterval: 5000
        enableXDR: true
        timeout: 60000

    $rootScope.websocketRequest.onOpen = (response) ->
        $rootScope.websocketTransport = response.transport
        $rootScope.websocketRequest.sendMessage()
        return

    $rootScope.websocketRequest.onClientTimeout = (r) ->
        $rootScope.websocketRequest.sendMessage()
        setTimeout (->
            $rootScope.websocketSubSocket = $rootScope.websocketSocket.subscribe($rootScope.websocketRequest)
            return
        ), $rootScope.websocketRequest.reconnectInterval
        return

    $rootScope.websocketRequest.onClose = (response) ->
        $rootScope.websocketRequest.sendMessage()  if $rootScope.websocketSubSocket
        return

    $rootScope.websocketRequest.sendMessage = ->
        if $rootScope.websocketSubSocket.request.isOpen
            if $rootScope.account?
                $rootScope.websocketSubSocket.push atmosphere.util.stringifyJSON(
                    userLogin: $rootScope.account.login
                    page: $state.current.templateUrl
                )
        return

    $rootScope.websocketSubSocket = $rootScope.websocketSocket.subscribe($rootScope.websocketRequest)
    $rootScope.$on "$stateChangeSuccess", (event, next, current) ->
        $rootScope.websocketRequest.sendMessage()
        return

    return
