'use strict';

angular.module('solrpressApp')
    .controller('BottomSheetController', function ($scope, $timeout, $mdBottomSheet) {
        $scope.alert = '';
        $scope.showListBottomSheet = function ($event) {
            $scope.alert = '';
            $mdBottomSheet.show({
                templateUrl: 'scripts/components/bottomsheet/bottom-sheet-list-template.html',
                controller: 'ListBottomSheetCtrl',
                targetEvent: $event
            }).then(function (clickedItem) {
                $scope.alert = clickedItem.name + ' clicked!';
            });
        };
        $scope.showGridBottomSheet = function ($event) {
            $scope.alert = '';
            $mdBottomSheet.show({
                templateUrl: 'scripts/components/bottomsheet/bottom-sheet-grid-template.html',
                controller: 'GridBottomSheetCtrl',
                targetEvent: $event
            }).then(function (clickedItem) {
                $scope.alert = clickedItem.name + ' clicked!';
            });
        };
    })
    .controller('ListBottomSheetCtrl', function ($scope, $mdBottomSheet) {
        $scope.items = [
            { name: 'Share', icon: 'share' },
            { name: 'Upload', icon: 'upload' },
            { name: 'Copy', icon: 'copy' },
            { name: 'Print this page', icon: 'print' }
        ];
        $scope.listItemClick = function ($index) {
            var clickedItem = $scope.items[$index];
            $mdBottomSheet.hide(clickedItem);
        };
    })
    .controller('GridBottomSheetCtrl', function ($scope, $mdBottomSheet) {
        $scope.items = [
            { name: 'Hangout', icon: 'hangout' },
            { name: 'Mail', icon: 'mail' },
            { name: 'Message', icon: 'message' },
            { name: 'Copy', icon: 'copy' },
            { name: 'Facebook', icon: 'facebook' },
            { name: 'Twitter', icon: 'twitter' }
        ];
        $scope.listItemClick = function ($index) {
            var clickedItem = $scope.items[$index];
            $mdBottomSheet.hide(clickedItem);
        };
    });
