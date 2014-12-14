'use strict'

angular.module('solrpressApp', [
    'LocalStorageModule'
    'tmh.dynamicLocale'
    'ngResource'
    'ui.router'
    'ngCookies'
    'pascalprecht.translate'
    'ngCacheBuster'
    'ui.bootstrap'
]).run(($rootScope, $location, $http, $state, $translate, Auth, Principal, Language) ->
    $rootScope.$on '$stateChangeStart', (event, toState, toStateParams) ->
        $rootScope.toState = toState
        $rootScope.toStateParams = toStateParams
        $http.get('protected/authentication_check.gif',
            ignoreErrors: true
        ).error ->
            if $rootScope.toState.data.roles.length > 0
                Auth.logout()
                $state.go 'login'
            return

        Auth.authorize()  if Principal.isIdentityResolved()
        Language.getCurrent().then (language) ->
            $translate.use language
            return

        return

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
        $rootScope.previousStateName = fromState.name
        $rootScope.previousStateParams = fromParams
        return

    $rootScope.back = ->
        if $rootScope.previousStateName is 'activate' or $state.get($rootScope.previousStateName) is null
            $state.go 'home'
        else
            $state.go $rootScope.previousStateName, $rootScope.previousStateParams
        return

    return
).config ($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider, $translateProvider, tmhDynamicLocaleProvider, httpRequestInterceptorCacheBusterProvider) ->
    $.material.init()
    $httpProvider.defaults.xsrfCookieName = 'CSRF-TOKEN'
    $httpProvider.defaults.xsrfHeaderName = 'X-CSRF-TOKEN'
    httpRequestInterceptorCacheBusterProvider.setMatchlist [
        /.*rest.*/
        /.*protected.*/
    ], true
    $urlRouterProvider.otherwise '/'
    $stateProvider.state 'site',
        abstract: true
        views:
            'navbar@':
                templateUrl: 'scripts/components/navbar/navbar.html'
                controller: 'NavbarController'

        resolve:
            authorize: [
                'Auth'
                (Auth) ->
                    return Auth.authorize()
            ]
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'global'
                    $translatePartialLoader.addPart 'language'
                    return $translate.refresh()
            ]

    $translateProvider.useLoader '$translatePartialLoader',
        urlTemplate: 'i18n/{lang}/{part}.json'

    $translateProvider.preferredLanguage 'en'
    $translateProvider.useCookieStorage()
    tmhDynamicLocaleProvider.localeLocationPattern 'bower_components/angular-i18n/angular-locale_{{locale}}.js'
    tmhDynamicLocaleProvider.useCookieStorage 'NG_TRANSLATE_LANG_KEY'
    return
