'use strict';
angular.module('solrpressApp', ['LocalStorageModule', 'tmh.dynamicLocale', 'ngResource', 'ui.router', 'ngCookies', 'pascalprecht.translate', 'ngCacheBuster', 'ngTouch', 'ngAria', 'ngSanitize', 'ui.grid', 'ui.grid.paging', 'ui.grid.resizeColumns', 'ui.grid.pinning', 'ui.grid.selection', 'ui.grid.moveColumns', 'ui.utils', 'ui.bootstrap', 'angularMoment', 'angularFileUpload', 'ncy-angular-breadcrumb']).run(function($rootScope, $location, $http, $state, $translate, Auth, Principal, Language, ENV, VERSION) {
  $rootScope.ENV = ENV;
  $rootScope.VERSION = VERSION;
  $rootScope.$on('$stateChangeStart', function(event, toState, toStateParams) {
    $rootScope.toState = toState;
    $rootScope.toStateParams = toStateParams;
    $rootScope.title = toState.title || toState.name;
    if (Principal.isIdentityResolved()) {
      Auth.authorize();
    }
    Language.getCurrent().then(function(language) {
      $translate.use(language);
    });
  });
  $rootScope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams) {
    $rootScope.previousStateName = fromState.name;
    $rootScope.previousStateParams = fromParams;
  });
  $rootScope.back = function() {
    if ($rootScope.previousStateName === 'activate' || $state.get($rootScope.previousStateName) === null) {
      $state.go('home');
    } else {
      $state.go($rootScope.previousStateName, $rootScope.previousStateParams);
    }
  };
}).factory('authInterceptor', function($rootScope, $q, $location, localStorageService) {
  return {
    request: function(config) {
      var token;
      config.headers = config.headers || {};
      token = localStorageService.get('token');
      if (token && token.expires_at && token.expires_at > (new Date).getTime()) {
        config.headers.Authorization = 'Bearer ' + token.access_token;
      }
      return config;
    }
  };
}).factory('loadingInterceptor', function($rootScope, $q, $cookieStore) {
  $rootScope.loading = 0;
  return {
    request: function(config) {
      $rootScope.loading++;
      config.headers = config.headers || {};
      if ($cookieStore.get('token')) {
        config.headers.Authorization = 'Bearer ' + $cookieStore.get('token');
      }
      return config;
    },
    response: function(response) {
      $rootScope.loading--;
      return response;
    },
    responseError: function(response) {
      $rootScope.loading--;
      return $q.reject(response);
    }
  };
}).config(function($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider, $translateProvider, tmhDynamicLocaleProvider, httpRequestInterceptorCacheBusterProvider, $breadcrumbProvider) {
  var defaultHeaders;
  $locationProvider.html5Mode(false);
  $.material.init();
  $httpProvider.defaults.xsrfCookieName = 'XSRF-TOKEN';
  $httpProvider.defaults.xsrfHeaderName = 'X-XSRF-TOKEN';
  defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept-Language': 'en',
    'X-Requested-With': 'XMLHttpRequest'
  };
  $httpProvider.defaults.headers["delete"] = defaultHeaders;
  $httpProvider.defaults.headers.patch = defaultHeaders;
  $httpProvider.defaults.headers.post = defaultHeaders;
  $httpProvider.defaults.headers.put = defaultHeaders;
  $httpProvider.defaults.headers.get = defaultHeaders;
  $breadcrumbProvider.setOptions({
    prefixStateName: "home",
    template: "bootstrap3"
  });
  httpRequestInterceptorCacheBusterProvider.setMatchlist([/.*api.*/, /.*protected.*/], true);
  $urlRouterProvider.otherwise('/');
  $stateProvider.state('site', {
    'abstract': true,
    views: {
      'navbar@': {
        templateUrl: 'scripts/components/navbar/navbar.html',
        controller: 'NavbarController'
      }
    },
    resolve: {
      authorize: [
        'Auth', function(Auth) {
          return Auth.authorize();
        }
      ],
      translatePartialLoader: [
        '$translate', '$translatePartialLoader', function($translate, $translatePartialLoader) {
          $translatePartialLoader.addPart('global');
          $translatePartialLoader.addPart('language');
          return $translate.refresh();
        }
      ]
    }
  });
  $httpProvider.interceptors.push('loadingInterceptor');
  $httpProvider.interceptors.push('authInterceptor');
  $translateProvider.useLoader('$translatePartialLoader', {
    urlTemplate: 'i18n/{lang}/{part}.json'
  });
  $translateProvider.preferredLanguage('en');
  $translateProvider.useCookieStorage();
  tmhDynamicLocaleProvider.localeLocationPattern('bower_components/angular-i18n/angular-locale_{{locale}}.js');
  tmhDynamicLocaleProvider.useCookieStorage('NG_TRANSLATE_LANG_KEY');
});
