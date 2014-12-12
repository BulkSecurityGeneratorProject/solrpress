
/**
@license HTTP Auth Interceptor Module for AngularJS
(c) 2012 Witold Szczerba
License: MIT
 */
(function() {
  "use strict";

  /**
  Call this function to indicate that authentication was successfull and trigger a
  retry of all deferred requests.
  @param data an optional argument to pass on to $broadcast which may be useful for
  example if you need to pass through details of the user that was logged in
   */

  /**
  Call this function to indicate that authentication should not proceed.
  All deferred requests will be abandoned or rejected (if reason is provided).
  @param data an optional argument to pass on to $broadcast.
  @param reason if provided, the requests are rejected; abandoned otherwise.
   */

  /**
  $http interceptor.
  On 401 response (without 'ignoreAuthModule' option) stores the request
  and broadcasts 'event:auth-loginRequired'.
   */
  angular.module("http-auth-interceptor", ["http-auth-interceptor-buffer"]).factory("authService", function($rootScope, httpBuffer) {
    return {
      loginConfirmed: function(data, configUpdater) {
        var updater;
        updater = configUpdater || function(config) {
          return config;
        };
        $rootScope.$broadcast("event:auth-loginConfirmed", data);
        httpBuffer.retryAll(updater);
      },
      loginCancelled: function(data, reason) {
        httpBuffer.rejectAll(reason);
        $rootScope.$broadcast("event:auth-loginCancelled", data);
      }
    };
  }).config(function($httpProvider) {
    var interceptor;
    interceptor = [
      "$rootScope", "$q", "httpBuffer", function($rootScope, $q, httpBuffer) {
        var error, success;
        success = function(response) {
          return response;
        };
        error = function(response) {
          var deferred;
          if (response.status === 401 && !response.config.ignoreAuthModule) {
            deferred = $q.defer();
            httpBuffer.append(response.config, deferred);
            $rootScope.$broadcast("event:auth-loginRequired", response);
            return deferred.promise;
          } else {
            if (response.status === 403 && !response.config.ignoreAuthModule) {
              $rootScope.$broadcast("event:auth-notAuthorized", response);
            }
          }
          return $q.reject(response);
        };
        return function(promise) {
          return promise.then(success, error);
        };
      }
    ];
    $httpProvider.interceptors.push(interceptor);
  });

  /**
  Private module, a utility, required internally by 'http-auth-interceptor'.
   */
  angular.module("http-auth-interceptor-buffer", []).factory("httpBuffer", function($injector) {

    /**
    Holds all the requests, so they can be re-requested in future.
     */

    /**
    Service initialized later because of circular dependency problem.
     */
    var $http, buffer, retryHttpRequest;
    retryHttpRequest = function(config, deferred) {
      var $http, errorCallback, successCallback;
      successCallback = function(response) {
        deferred.resolve(response);
      };
      errorCallback = function(response) {
        deferred.reject(response);
      };
      $http = $http || $injector.get("$http");
      $http(config).then(successCallback, errorCallback);
    };
    buffer = [];
    $http = void 0;
    return {

      /**
      Appends HTTP request configuration object with deferred response attached to buffer.
       */
      append: function(config, deferred) {
        buffer.push({
          config: config,
          deferred: deferred
        });
      },

      /**
      Abandon or reject (if reason provided) all the buffered requests.
       */
      rejectAll: function(reason) {
        var i;
        if (reason) {
          i = 0;
          while (i < buffer.length) {
            buffer[i].deferred.reject(reason);
            ++i;
          }
        }
        buffer = [];
      },

      /**
      Retries all the buffered requests clears the buffer.
       */
      retryAll: function(updater) {
        var i;
        i = 0;
        while (i < buffer.length) {
          retryHttpRequest(updater(buffer[i].config), buffer[i].deferred);
          ++i;
        }
        buffer = [];
      }
    };
  });
})();
