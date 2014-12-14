// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  angular.module('solrpressApp').controller('NavbarController', function($scope, $location, $state, Auth, Principal) {
    $scope.isAuthenticated = Principal.isAuthenticated;
    $scope.isInRole = Principal.isInRole;
    $scope.$state = $state;
    $scope.logout = function() {
      Auth.logout();
      $state.go('home');
    };
  });

}).call(this);
