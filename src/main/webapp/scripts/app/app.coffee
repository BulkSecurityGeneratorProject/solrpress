"use strict"

angular.module("solrpressApp", [
    'ngTouch'
    'ngCookies'
    'ngAria'
    'ngSanitize'
    'ui.router'
    'ngResource'
    'config'
    'LocalStorageModule'
    'ngLocale'
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
]).run(($scope, $location, $http, $state, $translate, Auth, Principal, Language) ->
    $scope.$on "$stateChangeStart", (event, toState, toStateParams) ->
        $scope.toState = toState
        $scope.toStateParams = toStateParams
        $http.get("protected/authentication_check.gif",
            ignoreErrors: true
        ).error ->
            if $scope.toState.data.roles.length > 0
                Auth.logout()
                $state.go "login"
            return

        Auth.authorize()  if Principal.isIdentityResolved()
        Language.getCurrent().then (language) ->
            $translate.use language
            return

        return

    $scope.$on "$stateChangeSuccess", (event, toState, toParams, fromState, fromParams) ->
        $scope.previousStateName = fromState.name
        $scope.previousStateParams = fromParams
        return

    $scope.back = ->
        if $scope.previousStateName is "activate" or $state.get($scope.previousStateName) is null
            $state.go "home"
        else
            $state.go $scope.previousStateName, $scope.previousStateParams
        return

    return
).factory("authInterceptor", ($scope, $q, $location, localStorageService) ->
    request: (config) ->
        config.headers = config.headers or {}
        token = localStorageService.get("token")
        config.headers.Authorization = "Bearer " + token.access_token  if token and token.expires_at and token.expires_at > new Date().getTime()
        config
).config ($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider, $translateProvider, tmhDynamicLocaleProvider, httpRequestInterceptorCacheBusterProvider) ->
    $locationProvider.html5Mode(true)
    $locationProvider.hashPrefix('#')
    $.material.init()
    $httpProvider.defaults.xsrfCookieName = 'XSRF-TOKEN'
    $httpProvider.defaults.xsrfHeaderName = 'X-XSRF-TOKEN'
    defaultHeaders =
        'Content-Type': 'application/json'
        'Accept-Language': 'en'
        'X-Requested-With': 'XMLHttpRequest'
    $httpProvider.defaults.headers.delete = defaultHeaders
    $httpProvider.defaults.headers.patch = defaultHeaders
    $httpProvider.defaults.headers.post = defaultHeaders
    $httpProvider.defaults.headers.put = defaultHeaders
    $httpProvider.defaults.headers.get = defaultHeaders

    #Cache everything except rest api requests
    httpRequestInterceptorCacheBusterProvider.setMatchlist [
        /.*rest.*/
        /.*protected.*/
    ], true

    $urlRouterProvider.otherwise "/"
    $stateProvider.state "site",
        abstract: true
        views:
            "navbar@":
                templateUrl: "scripts/components/navbar/navbar.html"
                controller: "NavbarController"

        resolve:
            authorize: [
                "Auth"
                (Auth) ->
                    return Auth.authorize()
            ]
            translatePartialLoader: [
                "$translate"
                "$translatePartialLoader"
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart "global"
                    $translatePartialLoader.addPart "language"
                    return $translate.refresh()
            ]

    $httpProvider.interceptors.push "authInterceptor"

    # Initialize angular-translate
    $translateProvider.useLoader "$translatePartialLoader",
        urlTemplate: "i18n/{lang}/{part}.json"

    $translateProvider.preferredLanguage "en"
    $translateProvider.useCookieStorage()
    tmhDynamicLocaleProvider.localeLocationPattern "bower_components/angular-i18n/angular-locale_{{locale}}.js"
    tmhDynamicLocaleProvider.useCookieStorage "NG_TRANSLATE_LANG_KEY"
    return

