// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  angular.module('solrpressApp').config(function($stateProvider) {
    $stateProvider.state('audits', {
      parent: 'admin',
      url: '/audits',
      data: {
        roles: ['ROLE_ADMIN']
      },
      views: {
        'content@': {
          templateUrl: 'scripts/app/admin/audits/audits.html',
          controller: 'AuditsController'
        }
      },
      resolve: {
        translatePartialLoader: [
          '$translate', '$translatePartialLoader', function($translate, $translatePartialLoader) {
            $translatePartialLoader.addPart('audits');
            return $translate.refresh();
          }
        ]
      }
    });
  }).controller('AuditsController', function($scope, $translate, $filter, AuditsService) {
    $scope.onChangeDate = function() {
      var dateFormat, fromDate, toDate;
      dateFormat = void 0;
      fromDate = void 0;
      toDate = void 0;
      dateFormat = 'yyyy-MM-dd';
      fromDate = $filter('date')($scope.fromDate, dateFormat);
      toDate = $filter('date')($scope.toDate, dateFormat);
      AuditsService.findByDates(fromDate, toDate).then(function(data) {
        $scope.audits = data;
      });
    };
    $scope.today = function() {
      var today;
      today = void 0;
      today = new Date();
      $scope.toDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);
    };
    $scope.previousMonth = function() {
      var fromDate;
      fromDate = void 0;
      fromDate = new Date();
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

}).call(this);
