'use strict'
angular.module('solrpressApp', [
    'LocalStorageModule'
    'tmh.dynamicLocale'
    'ngResource'
    'ui.router'
    'ngCookies'
    'pascalprecht.translate'
    'ngCacheBuster'
    'ngTouch'
    'ngAria'
    'ngSanitize'
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
    'ncy-angular-breadcrumb'
]).run(($rootScope, $location, $http, $state, $translate, Auth, Principal, Language, ENV, VERSION) ->
    $rootScope.ENV = ENV
    $rootScope.VERSION = VERSION
    $rootScope.$on '$stateChangeStart', (event, toState, toStateParams) ->
        $rootScope.toState = toState
        $rootScope.toStateParams = toStateParams
        $rootScope.title = toState.title or toState.name
        if Principal.isIdentityResolved()
            Auth.authorize()
        Language.getCurrent().then (language) ->
            $translate.use language
            return
        return
    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
        $rootScope.previousStateName = fromState.name
        $rootScope.previousStateParams = fromParams
        return

    $rootScope.back = ->
        if $rootScope.previousStateName == 'activate' or $state.get($rootScope.previousStateName) == null
            $state.go 'home'
        else
            $state.go $rootScope.previousStateName, $rootScope.previousStateParams
        return

    return
).factory('authInterceptor', ($rootScope, $q, $location, localStorageService) ->
    { request: (config) ->
        token = undefined
        config.headers = config.headers or {}
        token = localStorageService.get('token')
        if token and token.expires_at and token.expires_at > (new Date).getTime()
            config.headers.Authorization = 'Bearer ' + token.access_token
        config
    }
).factory('loadingInterceptor', ($rootScope, $q, $cookieStore) ->
    $rootScope.loading = 0
    {
    request: (config) ->
        $rootScope.loading++
        config.headers = config.headers or {}
        if $cookieStore.get('token')
            config.headers.Authorization = 'Bearer ' + $cookieStore.get('token')
        config
    response: (response) ->
        $rootScope.loading--
        response
    responseError: (response) ->
        $rootScope.loading--
        $q.reject response

    }
).config ($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider, $translateProvider, tmhDynamicLocaleProvider, httpRequestInterceptorCacheBusterProvider, $breadcrumbProvider) ->
    $locationProvider.html5Mode(false)
    $locationProvider.hashPrefix('!')
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

    $breadcrumbProvider.setOptions
        prefixStateName: 'home'
        template: 'bootstrap3'

    httpRequestInterceptorCacheBusterProvider.setMatchlist [
        /.*api.*/
        /.*protected.*/
    ], true

    $urlRouterProvider.otherwise '/'

    $stateProvider.state 'site',
        'abstract': true
        views:
            'navbar@':
                templateUrl: 'scripts/components/navbar/navbar.html'
                controller: 'NavbarController'
        resolve:
            authorize: [
                'Auth'
                (Auth) ->
                    Auth.authorize()
            ]
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'global'
                    $translatePartialLoader.addPart 'language'
                    $translate.refresh()
            ]
    $httpProvider.interceptors.push 'loadingInterceptor'
    $httpProvider.interceptors.push 'authInterceptor'

    $translateProvider.useLoader '$translatePartialLoader', urlTemplate: 'i18n/{lang}/{part}.json'
    $translateProvider.preferredLanguage 'en'
    $translateProvider.useCookieStorage()
    tmhDynamicLocaleProvider.localeLocationPattern 'bower_components/angular-i18n/angular-locale_{{locale}}.js'
    tmhDynamicLocaleProvider.useCookieStorage 'NG_TRANSLATE_LANG_KEY'
    return
