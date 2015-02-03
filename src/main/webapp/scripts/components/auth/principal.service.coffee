'use strict'
angular.module('solrpressApp').factory 'Principal', ($q, Account, Tracker) ->
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
      deferred = $q.defer()
      if force == true
        _identity = undefined
      # check and see if we have retrieved the identity data from the server.
      # if we have, reuse it by immediately resolving
      if angular.isDefined(_identity)
        deferred.resolve _identity
        return deferred.promise
      # retrieve the identity data from the server, update the identity object, and then resolve.
      Account.get().$promise.then((account) ->
        _identity = account.data
        _authenticated = true
        deferred.resolve _identity
        Tracker.connect()
        return
      ).catch ->
        _identity = null
        _authenticated = false
        deferred.resolve _identity
        return
      deferred.promise

  }
