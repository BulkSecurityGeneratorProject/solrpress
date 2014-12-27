// Generated by CoffeeScript 1.8.0
"use strict";
solrpressApp.controller("MainController", function($scope) {});

solrpressApp.controller("AdminController", function($scope) {});

solrpressApp.controller("LanguageController", function($scope, $translate, LanguageService) {
  $scope.changeLanguage = function(languageKey) {
    $translate.use(languageKey);
    LanguageService.getBy(languageKey).then(function(languages) {
      $scope.languages = languages;
    });
  };
  LanguageService.getBy().then(function(languages) {
    $scope.languages = languages;
  });
});

solrpressApp.controller("MenuController", function($scope) {});

solrpressApp.controller("LoginController", function($scope, $location, AuthenticationSharedService) {
  $scope.rememberMe = true;
  $scope.login = function() {
    AuthenticationSharedService.login({
      username: $scope.username,
      password: $scope.password,
      rememberMe: $scope.rememberMe
    });
  };
});

solrpressApp.controller("LogoutController", function($location, AuthenticationSharedService) {
  AuthenticationSharedService.logout();
});

solrpressApp.controller("SettingsController", function($scope, Account) {
  $scope.success = null;
  $scope.error = null;
  $scope.settingsAccount = Account.get();
  $scope.save = function() {
    $scope.success = null;
    $scope.error = null;
    $scope.errorEmailExists = null;
    Account.save($scope.settingsAccount, (function(value, responseHeaders) {
      $scope.error = null;
      $scope.success = "OK";
      $scope.settingsAccount = Account.get();
    }), function(httpResponse) {
      if (httpResponse.status === 400 && httpResponse.data === "e-mail address already in use") {
        $scope.errorEmailExists = "ERROR";
      } else {
        $scope.error = "ERROR";
      }
    });
  };
});

solrpressApp.controller("RegisterController", function($scope, $translate, Register) {
  $scope.success = null;
  $scope.error = null;
  $scope.doNotMatch = null;
  $scope.errorUserExists = null;
  $scope.register = function() {
    if ($scope.registerAccount.password !== $scope.confirmPassword) {
      $scope.doNotMatch = "ERROR";
    } else {
      $scope.registerAccount.langKey = $translate.use();
      $scope.doNotMatch = null;
      $scope.success = null;
      $scope.error = null;
      $scope.errorUserExists = null;
      $scope.errorEmailExists = null;
      Register.save($scope.registerAccount, (function(value, responseHeaders) {
        $scope.success = "OK";
      }), function(httpResponse) {
        if (httpResponse.status === 400 && httpResponse.data === "login already in use") {
          $scope.error = null;
          $scope.errorUserExists = "ERROR";
        } else if (httpResponse.status === 400 && httpResponse.data === "e-mail address already in use") {
          $scope.error = null;
          $scope.errorEmailExists = "ERROR";
        } else {
          $scope.error = "ERROR";
        }
      });
    }
  };
});

solrpressApp.controller("ActivationController", function($scope, $routeParams, Activate) {
  Activate.get({
    key: $routeParams.key
  }, (function(value, responseHeaders) {
    $scope.error = null;
    $scope.success = "OK";
  }), function(httpResponse) {
    $scope.success = null;
    return $scope.error = "ERROR";
  });
  return;
});

solrpressApp.controller("PasswordController", function($scope, Password) {
  $scope.success = null;
  $scope.error = null;
  $scope.doNotMatch = null;
  $scope.changePassword = function() {
    if ($scope.password !== $scope.confirmPassword) {
      $scope.doNotMatch = "ERROR";
    } else {
      $scope.doNotMatch = null;
      Password.save($scope.password, (function(value, responseHeaders) {
        $scope.error = null;
        $scope.success = "OK";
      }), function(httpResponse) {
        $scope.success = null;
        $scope.error = "ERROR";
      });
    }
  };
});

solrpressApp.controller("SessionsController", function($scope, resolvedSessions, Sessions) {
  $scope.success = null;
  $scope.error = null;
  $scope.sessions = resolvedSessions;
  $scope.invalidate = function(series) {
    Sessions["delete"]({
      series: encodeURIComponent(series)
    });
    return {
      succuess: function() {
        $scope.error = null;
        $scope.success = 'OK';
        return $scope.sessions = Sessions.get();
      }
    };
  };
});

solrpressApp.controller("TrackerController", function($scope) {
  $scope.activities = [];
  $scope.trackerSocket = atmosphere;
  $scope.trackerSubSocket;
  $scope.trackerTransport = "websocket";
  $scope.trackerRequest = {
    url: "websocket/tracker",
    contentType: "application/json",
    transport: $scope.trackerTransport,
    trackMessageLength: true,
    reconnectInterval: 5000,
    enableXDR: true,
    timeout: 60000
  };
  $scope.trackerRequest.onOpen = function(response) {
    $scope.trackerTransport = response.transport;
    $scope.trackerRequest.uuid = response.request.uuid;
  };
  $scope.trackerRequest.onMessage = function(response) {
    var activity, existingActivity, index, message;
    message = response.responseBody;
    activity = atmosphere.util.parseJSON(message);
    existingActivity = false;
    index = 0;
    while (index < $scope.activities.length) {
      if ($scope.activities[index].uuid === activity.uuid) {
        existingActivity = true;
        if (activity.page === "logout") {
          $scope.activities.splice(index, 1);
        } else {
          $scope.activities[index] = activity;
        }
      }
      index++;
    }
    if (!existingActivity) {
      $scope.activities.push(activity);
    }
    $scope.$apply();
  };
  $scope.trackerSubSocket = $scope.trackerSocket.subscribe($scope.trackerRequest);
});

solrpressApp.controller("HealthController", function($scope, HealthCheckService) {
  $scope.updatingHealth = true;
  $scope.refresh = function() {
    $scope.updatingHealth = true;
    HealthCheckService.check().then((function(promise) {
      $scope.healthCheck = promise;
      $scope.updatingHealth = false;
    }), function(promise) {
      $scope.healthCheck = promise.data;
      $scope.updatingHealth = false;
    });
  };
  $scope.refresh();
  $scope.getLabelClass = function(statusState) {
    if (statusState === "UP") {
      return "label-success";
    } else {
      return "label-danger";
    }
  };
});

solrpressApp.controller("ConfigurationController", function($scope, resolvedConfiguration) {
  $scope.configuration = resolvedConfiguration;
});

solrpressApp.controller("MetricsController", function($scope, MetricsService, HealthCheckService, ThreadDumpService) {
  $scope.metrics = {};
  $scope.updatingMetrics = true;
  $scope.refresh = function() {
    $scope.updatingMetrics = true;
    MetricsService.get().then((function(promise) {
      $scope.metrics = promise;
      $scope.updatingMetrics = false;
    }), function(promise) {
      $scope.metrics = promise.data;
      $scope.updatingMetrics = false;
    });
  };
  $scope.$watch("metrics", function(newValue, oldValue) {
    $scope.servicesStats = {};
    $scope.cachesStats = {};
    angular.forEach(newValue.timers, function(value, key) {
      var index, newKey;
      if (key.indexOf("web.rest") !== -1 || key.indexOf("service") !== -1) {
        $scope.servicesStats[key] = value;
      }
      if (key.indexOf("net.sf.ehcache.Cache") !== -1) {
        index = key.lastIndexOf(".");
        newKey = key.substr(0, index);
        index = newKey.lastIndexOf(".");
        $scope.cachesStats[newKey] = {
          name: newKey.substr(index + 1),
          value: value
        };
      }
    });
  });
  $scope.refresh();
  $scope.refreshThreadDumpData = function() {
    ThreadDumpService.dump().then(function(data) {
      $scope.threadDump = data;
      $scope.threadDumpRunnable = 0;
      $scope.threadDumpWaiting = 0;
      $scope.threadDumpTimedWaiting = 0;
      $scope.threadDumpBlocked = 0;
      angular.forEach(data, function(value, key) {
        if (value.threadState === "RUNNABLE") {
          $scope.threadDumpRunnable += 1;
        } else if (value.threadState === "WAITING") {
          $scope.threadDumpWaiting += 1;
        } else if (value.threadState === "TIMED_WAITING") {
          $scope.threadDumpTimedWaiting += 1;
        } else {
          if (value.threadState === "BLOCKED") {
            $scope.threadDumpBlocked += 1;
          }
        }
      });
      $scope.threadDumpAll = $scope.threadDumpRunnable + $scope.threadDumpWaiting + $scope.threadDumpTimedWaiting + $scope.threadDumpBlocked;
    });
  };
  $scope.getLabelClass = function(threadState) {
    if (threadState === "RUNNABLE") {
      return "label-success";
    } else if (threadState === "WAITING") {
      return "label-info";
    } else if (threadState === "TIMED_WAITING") {
      return "label-warning";
    } else {
      if (threadState === "BLOCKED") {
        return "label-danger";
      }
    }
  };
});

solrpressApp.controller("LogsController", function($scope, resolvedLogs, LogsService) {
  $scope.loggers = resolvedLogs;
  $scope.changeLevel = function(name, level) {
    LogsService.changeLevel({
      name: name,
      level: level
    }, function() {
      $scope.loggers = LogsService.findAll();
    });
  };
});

solrpressApp.controller("AuditsController", function($scope, $translate, $filter, AuditsService) {
  $scope.onChangeDate = function() {
    AuditsService.findByDates($scope.fromDate, $scope.toDate).then(function(data) {
      $scope.audits = data;
    });
  };
  $scope.today = function() {
    var today, tomorrow;
    today = new Date();
    tomorrow = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);
    $scope.toDate = $filter("date")(tomorrow, "yyyy-MM-dd");
  };
  $scope.previousMonth = function() {
    var fromDate;
    fromDate = new Date();
    if (fromDate.getMonth() === 0) {
      fromDate = new Date(fromDate.getFullYear() - 1, 0, fromDate.getDate());
    } else {
      fromDate = new Date(fromDate.getFullYear(), fromDate.getMonth() - 1, fromDate.getDate());
    }
    $scope.fromDate = $filter("date")(fromDate, "yyyy-MM-dd");
  };
  $scope.today();
  $scope.previousMonth();
  AuditsService.findByDates($scope.fromDate, $scope.toDate).then(function(data) {
    $scope.audits = data;
  });
});