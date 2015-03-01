'use strict'

angular.module('solrpressApp', [
    'LocalStorageModule'
    'tmh.dynamicLocale'
    'ngResource'
    'ui.router'
    'ngCookies'
    'pascalprecht.translate'
    'ngCacheBuster'
    'ngMaterial'
]).run(($rootScope, $location, $window, $http, $state, $translate, Auth, Principal, Language, ENV, VERSION) ->
    $rootScope.ENV = ENV
    $rootScope.VERSION = VERSION
    $rootScope.$on '$stateChangeStart', (event, toState, toStateParams) ->
        $rootScope.toState = toState
        $rootScope.toStateParams = toStateParams
        if Principal.isIdentityResolved()
            Auth.authorize()
        # Update the language
        Language.getCurrent().then (language) ->
            $translate.use language
            return
        return
    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
        titleKey = 'global.title'
        $rootScope.previousStateName = fromState.name
        $rootScope.previousStateParams = fromParams
        # Set the page title key to the one configured in state or use default one
        if toState.data.pageTitle
            titleKey = toState.data.pageTitle
        $translate(titleKey).then (title) ->
            # Change window title with translated one
            $window.document.title = title
            return
        return

    $rootScope.back = ->
        # If previous state is 'activate' or do not exist go to 'home'
        if $rootScope.previousStateName == 'activate' or $state.get($rootScope.previousStateName) == null
            $state.go 'home'
        else
            $state.go $rootScope.previousStateName, $rootScope.previousStateParams
        return

    return
).config ($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider, $translateProvider, tmhDynamicLocaleProvider, httpRequestInterceptorCacheBusterProvider, $mdThemingProvider) ->

    $mdThemingProvider.theme('default')
    .primaryPalette('pink')
    .accentPalette('orange')

    #enable CSRF
    $httpProvider.defaults.xsrfCookieName = 'CSRF-TOKEN'
    $httpProvider.defaults.xsrfHeaderName = 'X-CSRF-TOKEN'
    #Cache everything except rest api requests
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
    # Initialize angular-translate
    $translateProvider.useLoader '$translatePartialLoader', urlTemplate: 'i18n/{lang}/{part}.json'
    $translateProvider.preferredLanguage 'en'
    $translateProvider.useCookieStorage()
    tmhDynamicLocaleProvider.localeLocationPattern 'bower_components/angular-i18n/angular-locale_{{locale}}.js'
    tmhDynamicLocaleProvider.useCookieStorage 'NG_TRANSLATE_LANG_KEY'
    return
