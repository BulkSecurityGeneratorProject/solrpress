'use strict';
angular.module('solrpressApp').config(function($stateProvider) {
  $stateProvider.state('entity', {
    abstract: true,
    parent: 'site'
  });
});
