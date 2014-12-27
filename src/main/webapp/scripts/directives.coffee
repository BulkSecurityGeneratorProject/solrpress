"use strict"

angular.module("solrpressApp").directive("activeMenu", ($translate, $locale, tmhDynamicLocale) ->
  restrict: "A"
  link: (scope, element, attrs, controller) ->
    language = attrs.activeMenu
    scope.$watch (->
      $translate.use()
    ), (selectedLanguage) ->
      if language is selectedLanguage
        tmhDynamicLocale.set language
        element.addClass "active"
      else
        element.removeClass "active"
      return

    return
).directive("activeLink", (location) ->
  restrict: "A"
  link: (scope, element, attrs, controller) ->
    clazz = attrs.activeLink
    path = attrs.href
    path = path.substring(1)
    scope.location = location
    scope.$watch "location.path()", (newPath) ->
      if path is newPath
        element.addClass clazz
      else
        element.removeClass clazz
      return

    return
).directive("passwordStrengthBar", ->
  replace: true
  restrict: "E"
  template: "<div id=\"strength\">" + "<small translate=\"global.messages.validate.newpassword.strength\">Password strength:</small>" + "<ul id=\"strengthBar\">" + "<li class=\"point\"></li><li class=\"point\"></li><li class=\"point\"></li><li class=\"point\"></li><li class=\"point\"></li>" + "</ul>" + "</div>"
  link: (scope, iElement, attr) ->
    strength =
      colors: [
        "#F00"
        "#F90"
        "#FF0"
        "#9F0"
        "#0F0"
      ]
      mesureStrength: (p) ->
        _force = 0
        _regex = /[$-/:-?{-~!"^_`\[\]]/g
        _lowerLetters = /[a-z]+/.test(p)
        _upperLetters = /[A-Z]+/.test(p)
        _numbers = /[0-9]+/.test(p)
        _symbols = _regex.test(p)
        _flags = [
          _lowerLetters
          _upperLetters
          _numbers
          _symbols
        ]
        _passedMatches = $.grep(_flags, (el) ->
          el is true
        ).length
        _force += 2 * p.length + ((if (p.length >= 10) then 1 else 0))
        _force += _passedMatches * 10
        _force = (if (p.length <= 6) then Math.min(_force, 10) else _force)
        _force = (if (_passedMatches is 1) then Math.min(_force, 10) else _force)
        _force = (if (_passedMatches is 2) then Math.min(_force, 20) else _force)
        _force = (if (_passedMatches is 3) then Math.min(_force, 40) else _force)
        _force

      getColor: (s) ->
        idx = 0
        if s <= 10
          idx = 0
        else if s <= 20
          idx = 1
        else if s <= 30
          idx = 2
        else if s <= 40
          idx = 3
        else
          idx = 4
        idx: idx + 1
        col: @colors[idx]

    scope.$watch attr.passwordToCheck, (password) ->
      if password
        c = strength.getColor(strength.mesureStrength(password))
        iElement.removeClass "ng-hide"
        iElement.find("ul").children("li").css(background: "#DDD").slice(0, c.idx).css background: c.col
      return

    return
).directive "showValidation", ->
  restrict: "A"
  require: "form"
  link: (scope, element, attrs, formCtrl) ->
    element.find(".form-group").each ->
      $formGroup = $(this)
      $inputs = $formGroup.find("input[ng-model],textarea[ng-model],select[ng-model]")
      if $inputs.length > 0
        $inputs.each ->
          $input = $(this)
          scope.$watch (->
            $input.hasClass("ng-invalid") and $input.hasClass("ng-dirty")
          ), (isInvalid) ->
            $formGroup.toggleClass "has-error", isInvalid
            return

          return

      return

    return

