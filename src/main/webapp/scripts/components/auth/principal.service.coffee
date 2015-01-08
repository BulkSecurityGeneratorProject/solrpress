"use strict"

angular.module("solrpressApp").factory "Principal", Principal = ($q, Account, Tracker) ->
    _identity = undefined
    _authenticated = false
    isIdentityResolved: ->
        angular.isDefined _identity

    isAuthenticated: ->
        _authenticated

    isInRole: (role) ->
        return false  if not _authenticated or not _identity.roles
        _identity.roles.indexOf(role) isnt -1

    isInAnyRole: (roles) ->
        return false  if not _authenticated or not _identity.roles
        i = 0

        while i < roles.length
            return true  if @isInRole(roles[i])
            i++
        false

    authenticate: (identity) ->
        _identity = identity
        _authenticated = identity isnt null
        return

    identity: (force) ->
        deferred = $q.defer()
        _identity = `undefined`  if force is true

        # check and see if we have retrieved the identity data from the server.
        # if we have, reuse it by immediately resolving
        if angular.isDefined(_identity)
            deferred.resolve _identity
            return deferred.promise

        # retrieve the identity data from the server, update the identity object, and then resolve.
        Account.get().$promise

        .then (account) ->
            _identity = account.data
            _authenticated = true
            deferred.resolve _identity
            Tracker.connect()
            return
        .catch ->
            _identity = null
            _authenticated = false
            deferred.resolve(_identity)


        deferred.promise
