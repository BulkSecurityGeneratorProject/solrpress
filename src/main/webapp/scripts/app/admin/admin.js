'use strict';
angular.module('solrpressApp').config(function($stateProvider) {
  $stateProvider.state('admin', {
    abstract: true,
    parent: 'site'
  });
});
