'use strict';
angular.module('solrpressApp').controller('AuditsController', function($scope, $translate, $filter, AuditsService) {
  $scope.onChangeDate = function() {
    var dateFormat, fromDate, toDate;
    dateFormat = 'yyyy-MM-dd';
    fromDate = $filter('date')($scope.fromDate, dateFormat);
    toDate = $filter('date')($scope.toDate, dateFormat);
    AuditsService.findByDates(fromDate, toDate).then(function(data) {
      $scope.audits = data;
    });
  };
  $scope.today = function() {
    var today;
    today = new Date;
    $scope.toDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);
  };
  $scope.previousMonth = function() {
    var fromDate;
    fromDate = new Date;
    if (fromDate.getMonth() === 0) {
      fromDate = new Date(fromDate.getFullYear() - 1, 0, fromDate.getDate());
    } else {
      fromDate = new Date(fromDate.getFullYear(), fromDate.getMonth() - 1, fromDate.getDate());
    }
    $scope.fromDate = fromDate;
  };
  $scope.today();
  $scope.previousMonth();
  $scope.onChangeDate();
});
