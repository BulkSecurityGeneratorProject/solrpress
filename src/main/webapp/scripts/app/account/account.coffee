'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'account',
    abstract: true
    parent: 'site'
  return
