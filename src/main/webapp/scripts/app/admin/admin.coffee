'use strict'
angular.module('solrpressApp').config ($stateProvider) ->
  $stateProvider.state 'admin',
    abstract: true
    parent: 'site'
  return
