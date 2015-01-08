"use strict"

angular.module("solrpressApp").factory "Auth", Auth = ($rootScope, $state, $q, $translate, Principal, AuthServerProvider, Account, Register, Activate, Password, Tracker) ->

    login: (credentials, callback) ->
        cb = callback or angular.noop
        deferred = $q.defer()
        AuthServerProvider.login(credentials)

        .then (data) ->
            # retrieve the logged account information
            Principal.identity(true)
            .then (account) ->
                # After the login the language will be changed to
                # the language selected by the user during his registration
                $translate.use account.langKey
                Tracker.sendActivity()
                return
            .catch (err) ->
                @logout()
                deferred.reject(err)
                return cb(err)
            deferred.resolve data
            cb()

        deferred.promise

    logout: ->
        AuthServerProvider.logout()
        Principal.authenticate null
        return

    authorize: ->
        Principal.identity().then ->
            isAuthenticated = Principal.isAuthenticated()
            if $rootScope.toState.data.roles and $rootScope.toState.data.roles.length > 0 and not Principal.isInAnyRole($rootScope.toState.data.roles)
                if isAuthenticated

                    # user is signed in but not authorized for desired state
                    $state.go "accessdenied"
                else

                    # user is not authenticated. stow the state they wanted before you
                    # send them to the signin state, so you can return them when you're done
                    $rootScope.returnToState = $rootScope.toState
                    $rootScope.returnToStateParams = $rootScope.toStateParams

                    # now, send them to the signin state so they can log in
                    $state.go "login"
            return


    createAccount: (account, callback) ->
        cb = callback or angular.noop
        Register.save(account, ->
            cb account
        , ((err) ->
                @logout()
                cb err
            ).bind(this)).$promise

    updateAccount: (account, callback) ->
        cb = callback or angular.noop
        Account.save(account, ->
            cb account
        , ((err) ->
                cb err
            ).bind(this)).$promise

    activateAccount: (key, callback) ->
        cb = callback or angular.noop
        Activate.get(key, (response) ->
            cb response
        , ((err) ->
                cb err
            ).bind(this)).$promise

    changePassword: (newPassword, callback) ->
        cb = callback or angular.noop
        Password.save(newPassword, ->
            cb()
        , (err) ->
            cb err
        ).$promise
