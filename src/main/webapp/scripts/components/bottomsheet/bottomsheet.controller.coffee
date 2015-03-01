'use strict'
angular.module('solrpressApp').controller('BottomSheetController', ($scope, $timeout, $mdBottomSheet) ->
  $scope.alert = ''

  $scope.showListBottomSheet = ($event) ->
    $scope.alert = ''
    $mdBottomSheet.show(
      templateUrl: 'scripts/components/bottomsheet/bottom-sheet-list-template.html'
      controller: 'ListBottomSheetCtrl'
      targetEvent: $event).then (clickedItem) ->
      $scope.alert = clickedItem.name + ' clicked!'
      return
    return

  $scope.showGridBottomSheet = ($event) ->
    $scope.alert = ''
    $mdBottomSheet.show(
      templateUrl: 'scripts/components/bottomsheet/bottom-sheet-grid-template.html'
      controller: 'GridBottomSheetCtrl'
      targetEvent: $event).then (clickedItem) ->
      $scope.alert = clickedItem.name + ' clicked!'
      return
    return

  return
).controller('ListBottomSheetCtrl', ($scope, $mdBottomSheet) ->
  $scope.items = [
    {
      name: 'Share'
      icon: 'share'
    }
    {
      name: 'Upload'
      icon: 'upload'
    }
    {
      name: 'Copy'
      icon: 'copy'
    }
    {
      name: 'Print this page'
      icon: 'print'
    }
  ]

  $scope.listItemClick = ($index) ->
    clickedItem = $scope.items[$index]
    $mdBottomSheet.hide clickedItem
    return

  return
).controller 'GridBottomSheetCtrl', ($scope, $mdBottomSheet) ->
  $scope.items = [
    {
      name: 'Hangout'
      icon: 'hangout'
    }
    {
      name: 'Mail'
      icon: 'mail'
    }
    {
      name: 'Message'
      icon: 'message'
    }
    {
      name: 'Copy'
      icon: 'copy'
    }
    {
      name: 'Facebook'
      icon: 'facebook'
    }
    {
      name: 'Twitter'
      icon: 'twitter'
    }
  ]

  $scope.listItemClick = ($index) ->
    clickedItem = $scope.items[$index]
    $mdBottomSheet.hide clickedItem
    return

  return
