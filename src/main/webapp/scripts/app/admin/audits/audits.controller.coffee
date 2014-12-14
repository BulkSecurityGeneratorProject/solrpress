'use strict'

angular.module('solrpressApp').config(($stateProvider) ->
    $stateProvider.state 'audits',
        parent: 'admin'
        url: '/audits'
        data:
            roles: ['ROLE_ADMIN']

        views:
            'content@':
                templateUrl: 'scripts/app/admin/audits/audits.html'
                controller: 'AuditsController'

        resolve:
            translatePartialLoader: [
                '$translate'
                '$translatePartialLoader'
                ($translate, $translatePartialLoader) ->
                    $translatePartialLoader.addPart 'audits'
                    return $translate.refresh()
            ]

    return
).controller 'AuditsController', ($scope, $translate, $filter, AuditsService) ->
    $scope.onChangeDate = ->
        dateFormat = undefined
        fromDate = undefined
        toDate = undefined
        dateFormat = 'yyyy-MM-dd'
        fromDate = $filter('date')($scope.fromDate, dateFormat)
        toDate = $filter('date')($scope.toDate, dateFormat)
        AuditsService.findByDates(fromDate, toDate).then (data) ->
            $scope.audits = data
            return

        return

    $scope.today = ->
        today = undefined
        today = new Date()
        $scope.toDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1)
        return

    $scope.previousMonth = ->
        fromDate = undefined
        fromDate = new Date()
        if fromDate.getMonth() is 0
            fromDate = new Date(fromDate.getFullYear() - 1, 0, fromDate.getDate())
        else
            fromDate = new Date(fromDate.getFullYear(), fromDate.getMonth() - 1, fromDate.getDate())
        $scope.fromDate = fromDate
        return

    $scope.today()
    $scope.previousMonth()
    $scope.onChangeDate()
    return

