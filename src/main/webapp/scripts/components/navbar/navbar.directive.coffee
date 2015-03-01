'use strict'
angular.module('solrpressApp').directive('activeMenu', ($translate, $locale, tmhDynamicLocale) ->
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      language = attrs.activeMenu
      scope.$watch (->
        $translate.use()
      ), (selectedLanguage) ->
        if language == selectedLanguage
          tmhDynamicLocale.set language
          element.addClass 'active'
        else
          element.removeClass 'active'
        return
      return

  }
).directive 'activeLink', (location) ->
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      clazz = attrs.activeLink
      path = attrs.href
      path = path.substring(1)
      #hack because path does bot return including hashbang
      scope.location = location
      scope.$watch 'location.path()', (newPath) ->
        if path == newPath
          element.addClass clazz
        else
          element.removeClass clazz
        return
      return

  }
