### globals $ ###

'use strict'
angular.module('solrpressApp').directive 'showValidation', ->
  {
    restrict: 'A'
    require: 'form'
    link: (scope, element) ->
      element.find('.form-group').each ->
        $formGroup = $(this)
        $inputs = $formGroup.find('input[ng-model],textarea[ng-model],select[ng-model]')
        if $inputs.length > 0
          $inputs.each ->
            $input = $(this)
            scope.$watch (->
              $input.hasClass('ng-invalid') and $input.hasClass('ng-dirty')
            ), (isInvalid) ->
              $formGroup.toggleClass 'has-error', isInvalid
              return
            return
        return
      return

  }
