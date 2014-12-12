"use strict";
angular.module("solrpressApp").directive("activeMenu", function($translate, $locale, tmhDynamicLocale) {
  return {
    restrict: "A",
    link: function(scope, element, attrs, controller) {
      var language;
      language = attrs.activeMenu;
      scope.$watch((function() {
        return $translate.use();
      }), function(selectedLanguage) {
        if (language === selectedLanguage) {
          tmhDynamicLocale.set(language);
          element.addClass("active");
        } else {
          element.removeClass("active");
        }
      });
    }
  };
}).directive("activeLink", function(location) {
  return {
    restrict: "A",
    link: function(scope, element, attrs, controller) {
      var clazz, path;
      clazz = attrs.activeLink;
      path = attrs.href;
      path = path.substring(1);
      scope.location = location;
      scope.$watch("location.path()", function(newPath) {
        if (path === newPath) {
          element.addClass(clazz);
        } else {
          element.removeClass(clazz);
        }
      });
    }
  };
}).directive("passwordStrengthBar", function() {
  return {
    replace: true,
    restrict: "E",
    template: "<div id=\"strength\">" + "<small translate=\"global.messages.validate.newpassword.strength\">Password strength:</small>" + "<ul id=\"strengthBar\">" + "<li class=\"point\"></li><li class=\"point\"></li><li class=\"point\"></li><li class=\"point\"></li><li class=\"point\"></li>" + "</ul>" + "</div>",
    link: function(scope, iElement, attr) {
      var strength;
      strength = {
        colors: ["#F00", "#F90", "#FF0", "#9F0", "#0F0"],
        mesureStrength: function(p) {
          var _flags, _force, _lowerLetters, _numbers, _passedMatches, _regex, _symbols, _upperLetters;
          _force = 0;
          _regex = /[$-/:-?{-~!"^_`\[\]]/g;
          _lowerLetters = /[a-z]+/.test(p);
          _upperLetters = /[A-Z]+/.test(p);
          _numbers = /[0-9]+/.test(p);
          _symbols = _regex.test(p);
          _flags = [_lowerLetters, _upperLetters, _numbers, _symbols];
          _passedMatches = $.grep(_flags, function(el) {
            return el === true;
          }).length;
          _force += 2 * p.length + (p.length >= 10 ? 1 : 0);
          _force += _passedMatches * 10;
          _force = (p.length <= 6 ? Math.min(_force, 10) : _force);
          _force = (_passedMatches === 1 ? Math.min(_force, 10) : _force);
          _force = (_passedMatches === 2 ? Math.min(_force, 20) : _force);
          _force = (_passedMatches === 3 ? Math.min(_force, 40) : _force);
          return _force;
        },
        getColor: function(s) {
          var idx;
          idx = 0;
          if (s <= 10) {
            idx = 0;
          } else if (s <= 20) {
            idx = 1;
          } else if (s <= 30) {
            idx = 2;
          } else if (s <= 40) {
            idx = 3;
          } else {
            idx = 4;
          }
          return {
            idx: idx + 1,
            col: this.colors[idx]
          };
        }
      };
      scope.$watch(attr.passwordToCheck, function(password) {
        var c;
        if (password) {
          c = strength.getColor(strength.mesureStrength(password));
          iElement.removeClass("ng-hide");
          iElement.find("ul").children("li").css({
            background: "#DDD"
          }).slice(0, c.idx).css({
            background: c.col
          });
        }
      });
    }
  };
}).directive("showValidation", function() {
  return {
    restrict: "A",
    require: "form",
    link: function(scope, element, attrs, formCtrl) {
      element.find(".form-group").each(function() {
        var $formGroup, $inputs;
        $formGroup = $(this);
        $inputs = $formGroup.find("input[ng-model],textarea[ng-model],select[ng-model]");
        if ($inputs.length > 0) {
          $inputs.each(function() {
            var $input;
            $input = $(this);
            scope.$watch((function() {
              return $input.hasClass("ng-invalid") && $input.hasClass("ng-dirty");
            }), function(isInvalid) {
              $formGroup.toggleClass("has-error", isInvalid);
            });
          });
        }
      });
    }
  };
});
