'use strict'
angular.module('solrpressApp').factory 'Principal', ($q, Account, Tracker) ->
  _authenticated = undefined
  _identity = undefined
  _identity = undefined
  _authenticated = false
  {
    isIdentityResolved: ->
      angular.isDefined _identity
    isAuthenticated: ->
      _authenticated
    isInRole: (role) ->
      if !_authenticated or !_identity.roles
        return false
      _identity.roles.indexOf(role) != -1
    isInAnyRole: (roles) ->
      i = undefined
      if !_authenticated or !_identity.roles
        return false
      i = 0
      while i < roles.length
        if @isInRole(roles[i])
          return true
        i++
      false
    authenticate: (identity) ->
      _identity = identity
      _authenticated = identity != null
      return
    identity: (force) ->
      deferred = undefined
      deferred = $q.defer()
      if force == true
        _identity = undefined
      if angular.isDefined(_identity)
        deferred.resolve _identity
        return deferred.promise
      Account.get().$promise.then((account) ->
        _identity = account.data
        _authenticated = true
        deferred.resolve _identity
        Tracker.connect()
        return
      )['catch'] ->
        _identity = null
        _authenticated = false
        deferred.resolve _identity
        return
      deferred.promise

  }
