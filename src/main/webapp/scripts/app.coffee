#global angular:true, browser:true
'use strict'

solrpressApp = angular.module('solrpressApp', [
    'http-auth-interceptor',
    'tmh.dynamicLocale',
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'pascalprecht.translate',
    'ui.router',
    'ui.utils',
    'ui.bootstrap',
    'infinite-scroll',
    'angularMoment',
    'angularFileUpload',
    'solrpressAppUtils',
    'truncate',
    'ngCacheBuster'
])


solrpressApp.config(($stateProvider, $urlRouterProvider, $httpProvider, $translateProvider, tmhDynamicLocaleProvider, httpRequestInterceptorCacheBusterProvider, USER_ROLES) ->
    httpRequestInterceptorCacheBusterProvider.setMatchlist [/.*rest.*/], true
    $urlRouterProvider.when("/register",
        templateUrl: "views/register.html"
        controller: "RegisterController"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).when("/activate",
        templateUrl: "views/activate.html"
        controller: "ActivationController"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).when("/login",
        templateUrl: "views/login.html"
        controller: "LoginController"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).when("/error",
        templateUrl: "views/error.html"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).when("/settings",
        templateUrl: "views/settings.html"
        controller: "SettingsController"
        access:
            authorizedRoles: [USER_ROLES.user]
    ).when("/password",
        templateUrl: "views/password.html"
        controller: "PasswordController"
        access:
            authorizedRoles: [USER_ROLES.user]
    ).when("/sessions",
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
    ).when("/tracker",
        templateUrl: "views/tracker.html"
        controller: "TrackerController"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).when("/metrics",
        templateUrl: "views/metrics.html"
        controller: "MetricsController"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).when("/health",
        templateUrl: "views/health.html"
        controller: "HealthController"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).when("/configuration",
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
    ).when("/logs",
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
    ).when("/audits",
        templateUrl: "views/audits.html"
        controller: "AuditsController"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).when("/logout",
        templateUrl: "views/main.html"
        controller: "LogoutController"
        access:
            authorizedRoles: [USER_ROLES.all]
    ).when("/docs",
        templateUrl: "views/docs.html"
        access:
            authorizedRoles: [USER_ROLES.admin]
    ).otherwise
        templateUrl: "views/main.html"
        controller: "MainController"
        access:
            authorizedRoles: [USER_ROLES.all]

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
    $rootScope.$on "$routeChangeStart", (event, next) ->
        $rootScope.isAuthorized = AuthenticationSharedService.isAuthorized
        $rootScope.userRoles = USER_ROLES
        AuthenticationSharedService.valid next.access.authorizedRoles
        return

    $rootScope.$on "event:auth-loginConfirmed", (data) ->
        $rootScope.authenticated = true
        if $location.path() is "/login"
            search = $location.search()
            if search.redirect isnt `undefined`
                $location.path(search.redirect).search("redirect", null).replace()
            else
                $location.path("/").replace()
        return

    $rootScope.$on "event:auth-loginRequired", (rejection) ->
        Session.invalidate()
        $rootScope.authenticated = false
        if $location.path() isnt "/" and $location.path() isnt "" and $location.path() isnt "/register" and $location.path() isnt "/activate" and $location.path() isnt "/login"
            redirect = $location.path()
            $location.path("/login").search("redirect", redirect).replace()
        return

    $rootScope.$on "event:auth-notAuthorized", (rejection) ->
        $rootScope.errorMessage = "errors.403"
        $location.path("/error").replace()
        return

    $rootScope.$on "event:auth-loginCancelled", ->
        $location.path ""
        return

    return
).run ($rootScope, $route) ->

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
                    page: $route.currentRoute.templateUrl
                )
        return

    $rootScope.websocketSubSocket = $rootScope.websocketSocket.subscribe($rootScope.websocketRequest)
    $rootScope.$on "$stateChangeStart", (event, currentRoute, previousRoute) ->
        $rootScope.title = currentRoute.title or currentRoute.name
        $rootScope.userRoles = USER_ROLES
        $rootScope.websocketRequest.sendMessage()
        return

    return
