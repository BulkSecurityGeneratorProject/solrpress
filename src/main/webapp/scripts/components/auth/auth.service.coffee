'use strict'
angular.module('solrpressApp').factory 'Auth', ($rootScope, $state, $q, $translate, Principal, AuthServerProvider, Account, Register, Activate, Password, Tracker) ->
  {
    login: (credentials, callback) ->
      cb = undefined
      deferred = undefined
      cb = callback or angular.noop
      deferred = $q.defer()
      AuthServerProvider.login(credentials).then((data) ->
        Principal.identity(true).then (account) ->
          $translate.use account.langKey
          Tracker.sendActivity()
          return
        deferred.resolve data
        cb()
      )['catch'] ((err) ->
        @logout()
        deferred.reject err
        cb err
      ).bind(this)
      deferred.promise
    logout: ->
      AuthServerProvider.logout()
      Principal.authenticate null
      return
    authorize: ->
      Principal.identity().then ->
        isAuthenticated = undefined
        isAuthenticated = Principal.isAuthenticated()
        if $rootScope.toState.data.roles and $rootScope.toState.data.roles.length > 0 and !Principal.isInAnyRole($rootScope.toState.data.roles)
          if isAuthenticated
            $state.go 'accessdenied'
          else
            $rootScope.returnToState = $rootScope.toState
            $rootScope.returnToStateParams = $rootScope.toStateParams
            $state.go 'login'
        return
    createAccount: (account, callback) ->
      cb = undefined
      cb = callback or angular.noop
      Register.save(account, (->
        cb account
      ), ((err) ->
        @logout()
        cb err
      ).bind(this)).$promise
    updateAccount: (account, callback) ->
      cb = undefined
      cb = callback or angular.noop
      Account.save(account, (->
        cb account
      ), ((err) ->
        cb err
      ).bind(this)).$promise
    activateAccount: (key, callback) ->
      cb = undefined
      cb = callback or angular.noop
      Activate.get(key, ((response) ->
        cb response
      ), ((err) ->
        cb err
      ).bind(this)).$promise
    changePassword: (newPassword, callback) ->
      cb = undefined
      cb = callback or angular.noop
      Password.save(newPassword, (->
        cb()
      ), (err) ->
        cb err
      ).$promise

  }
