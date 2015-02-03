'use strict';
angular.module('solrpressApp').controller('ConfigurationController', function($scope, ConfigurationService) {
  ConfigurationService.get().then(function(configuration) {
    $scope.configuration = configuration;
  });
});
