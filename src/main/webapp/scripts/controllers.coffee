"use strict"

# Controllers
solrpressApp.controller "MainController", ($scope) ->


solrpressApp.controller "AdminController", ($scope) ->


solrpressApp.controller "LanguageController", ($scope, $translate, LanguageService) ->
    $scope.changeLanguage = (languageKey) ->
        $translate.use languageKey
        LanguageService.getBy(languageKey).then (languages) ->
            $scope.languages = languages
            return

        return

    LanguageService.getBy().then (languages) ->
        $scope.languages = languages
        return

    return

solrpressApp.controller "MenuController", ($scope) ->

solrpressApp.controller "LoginController", ($scope, $location, AuthenticationSharedService) ->
    $scope.rememberMe = true
    $scope.login = ->
        AuthenticationSharedService.login
            username: $scope.username
            password: $scope.password
            rememberMe: $scope.rememberMe

        return

    return

solrpressApp.controller "LogoutController", ($location, AuthenticationSharedService) ->
    AuthenticationSharedService.logout()
    return

solrpressApp.controller "SettingsController", ($scope, Account) ->
    $scope.success = null
    $scope.error = null
    $scope.settingsAccount = Account.get()
    $scope.save = ->
        $scope.success = null
        $scope.error = null
        $scope.errorEmailExists = null
        Account.save $scope.settingsAccount, ((value, responseHeaders) ->
            $scope.error = null
            $scope.success = "OK"
            $scope.settingsAccount = Account.get()
            return
        ), (httpResponse) ->
            if httpResponse.status is 400 and httpResponse.data is "e-mail address already in use"
                $scope.errorEmailExists = "ERROR"
            else
                $scope.error = "ERROR"
            return

        return

    return

solrpressApp.controller "RegisterController", ($scope, $translate, Register) ->
    $scope.success = null
    $scope.error = null
    $scope.doNotMatch = null
    $scope.errorUserExists = null
    $scope.register = ->
        if $scope.registerAccount.password isnt $scope.confirmPassword
            $scope.doNotMatch = "ERROR"
        else
            $scope.registerAccount.langKey = $translate.use()
            $scope.doNotMatch = null
            $scope.success = null
            $scope.error = null
            $scope.errorUserExists = null
            $scope.errorEmailExists = null
            Register.save $scope.registerAccount, ((value, responseHeaders) ->
                $scope.success = "OK"
                return
            ), (httpResponse) ->
                if httpResponse.status is 400 and httpResponse.data is "login already in use"
                    $scope.error = null
                    $scope.errorUserExists = "ERROR"
                else if httpResponse.status is 400 and httpResponse.data is "e-mail address already in use"
                    $scope.error = null
                    $scope.errorEmailExists = "ERROR"
                else
                    $scope.error = "ERROR"
                return

        return

    return

solrpressApp.controller "ActivationController", ($scope, $routeParams, Activate) ->
    Activate.get
        key: $routeParams.key
    , ((value, responseHeaders) ->
            $scope.error = null
            $scope.success = "OK"
            return
        ), (httpResponse) ->
        $scope.success = null
        $scope.error = "ERROR"
    return

    return

solrpressApp.controller "PasswordController", ($scope, Password) ->
    $scope.success = null
    $scope.error = null
    $scope.doNotMatch = null
    $scope.changePassword = ->
        unless $scope.password is $scope.confirmPassword
            $scope.doNotMatch = "ERROR"
        else
            $scope.doNotMatch = null
            Password.save $scope.password, ((value, responseHeaders) ->
                $scope.error = null
                $scope.success = "OK"
                return
            ), (httpResponse) ->
                $scope.success = null
                $scope.error = "ERROR"
                return

        return

    return

solrpressApp.controller "SessionsController", ($scope, resolvedSessions, Sessions) ->
    $scope.success = null
    $scope.error = null
    $scope.sessions = resolvedSessions
    $scope.invalidate = (series) ->
        Sessions.delete
            series: encodeURIComponent(series)
        succuess: () ->
            $scope.error = null;
            $scope.success = 'OK';
            $scope.sessions = Sessions.get();



    return


# Sessions.delete({series: encodeURIComponent(series)},
#     function (value, responseHeaders) {
#         $scope.error = null;
#         $scope.success = 'OK';
#         $scope.sessions = Sessions.get();
#     },
#     function (httpResponse) {
#         $scope.success = null;
#         $scope.error = 'ERROR';
#     });
solrpressApp.controller "TrackerController", ($scope) ->

    # This controller uses the Atmosphere framework to keep a Websocket connection opened, and receive
    # user activities in real-time.
    $scope.activities = []
    $scope.trackerSocket = atmosphere
    $scope.trackerSubSocket
    $scope.trackerTransport = "websocket"
    $scope.trackerRequest =
        url: "websocket/tracker"
        contentType: "application/json"
        transport: $scope.trackerTransport
        trackMessageLength: true
        reconnectInterval: 5000
        enableXDR: true
        timeout: 60000

    $scope.trackerRequest.onOpen = (response) ->
        $scope.trackerTransport = response.transport
        $scope.trackerRequest.uuid = response.request.uuid
        return

    $scope.trackerRequest.onMessage = (response) ->
        message = response.responseBody
        activity = atmosphere.util.parseJSON(message)
        existingActivity = false
        index = 0

        while index < $scope.activities.length
            if $scope.activities[index].uuid is activity.uuid
                existingActivity = true
                if activity.page is "logout"
                    $scope.activities.splice index, 1
                else
                    $scope.activities[index] = activity
            index++
        $scope.activities.push activity  unless existingActivity
        $scope.$apply()
        return

    $scope.trackerSubSocket = $scope.trackerSocket.subscribe($scope.trackerRequest)
    return

solrpressApp.controller "HealthController", ($scope, HealthCheckService) ->
    $scope.updatingHealth = true
    $scope.refresh = ->
        $scope.updatingHealth = true
        HealthCheckService.check().then ((promise) ->
            $scope.healthCheck = promise
            $scope.updatingHealth = false
            return
        ), (promise) ->
            $scope.healthCheck = promise.data
            $scope.updatingHealth = false
            return

        return

    $scope.refresh()
    $scope.getLabelClass = (statusState) ->
        if statusState is "UP"
            "label-success"
        else
            "label-danger"

    return

solrpressApp.controller "ConfigurationController", ($scope, resolvedConfiguration) ->
    $scope.configuration = resolvedConfiguration
    return

solrpressApp.controller "MetricsController", ($scope, MetricsService, HealthCheckService, ThreadDumpService) ->
    $scope.metrics = {}
    $scope.updatingMetrics = true
    $scope.refresh = ->
        $scope.updatingMetrics = true
        MetricsService.get().then ((promise) ->
            $scope.metrics = promise
            $scope.updatingMetrics = false
            return
        ), (promise) ->
            $scope.metrics = promise.data
            $scope.updatingMetrics = false
            return

        return

    $scope.$watch "metrics", (newValue, oldValue) ->
        $scope.servicesStats = {}
        $scope.cachesStats = {}
        angular.forEach newValue.timers, (value, key) ->
            $scope.servicesStats[key] = value  if key.indexOf("web.rest") isnt -1 or key.indexOf("service") isnt -1
            unless key.indexOf("net.sf.ehcache.Cache") is -1

                # remove gets or puts
                index = key.lastIndexOf(".")
                newKey = key.substr(0, index)

                # Keep the name of the domain
                index = newKey.lastIndexOf(".")
                $scope.cachesStats[newKey] =
                    name: newKey.substr(index + 1)
                    value: value
            return

        return

    $scope.refresh()
    $scope.refreshThreadDumpData = ->
        ThreadDumpService.dump().then (data) ->
            $scope.threadDump = data
            $scope.threadDumpRunnable = 0
            $scope.threadDumpWaiting = 0
            $scope.threadDumpTimedWaiting = 0
            $scope.threadDumpBlocked = 0
            angular.forEach data, (value, key) ->
                if value.threadState is "RUNNABLE"
                    $scope.threadDumpRunnable += 1
                else if value.threadState is "WAITING"
                    $scope.threadDumpWaiting += 1
                else if value.threadState is "TIMED_WAITING"
                    $scope.threadDumpTimedWaiting += 1
                else $scope.threadDumpBlocked += 1  if value.threadState is "BLOCKED"
                return

            $scope.threadDumpAll = $scope.threadDumpRunnable + $scope.threadDumpWaiting + $scope.threadDumpTimedWaiting + $scope.threadDumpBlocked
            return

        return

    $scope.getLabelClass = (threadState) ->
        if threadState is "RUNNABLE"
            "label-success"
        else if threadState is "WAITING"
            "label-info"
        else if threadState is "TIMED_WAITING"
            "label-warning"
        else "label-danger"  if threadState is "BLOCKED"

    return

solrpressApp.controller "LogsController", ($scope, resolvedLogs, LogsService) ->
    $scope.loggers = resolvedLogs
    $scope.changeLevel = (name, level) ->
        LogsService.changeLevel
            name: name
            level: level
        , ->
            $scope.loggers = LogsService.findAll()
            return

        return

    return

solrpressApp.controller "AuditsController", ($scope, $translate, $filter, AuditsService) ->
    $scope.onChangeDate = ->
        AuditsService.findByDates($scope.fromDate, $scope.toDate).then (data) ->
            $scope.audits = data
            return

        return


    # Date picker configuration
    $scope.today = ->

        # Today + 1 day - needed if the current day must be included
        today = new Date()
        tomorrow = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1) # create new increased date
        $scope.toDate = $filter("date")(tomorrow, "yyyy-MM-dd")
        return

    $scope.previousMonth = ->
        fromDate = new Date()
        if fromDate.getMonth() is 0
            fromDate = new Date(fromDate.getFullYear() - 1, 0, fromDate.getDate())
        else
            fromDate = new Date(fromDate.getFullYear(), fromDate.getMonth() - 1, fromDate.getDate())
        $scope.fromDate = $filter("date")(fromDate, "yyyy-MM-dd")
        return

    $scope.today()
    $scope.previousMonth()
    AuditsService.findByDates($scope.fromDate, $scope.toDate).then (data) ->
        $scope.audits = data
        return

    return
