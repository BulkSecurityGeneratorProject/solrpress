'use strict';

/**
 * Created by ferdous on 1/9/15.
 */
(function($) {
  var isset;
  isset = function(variable) {
    if (typeof variable !== 'undefined' && variable !== null) {
      return true;
    } else {
      return false;
    }
  };
  $(document).ready(function() {
    $('body').append('<div id=flash-container/>');
  });
  $(document).on('click', '[data-toggle=flash]', function() {
    $(this).flash('toggle');
  }).on('click', '#flash-container .flash', function() {
    $(this).flash('hide');
  });
  $.flash = function(options) {
    var $flash, animationId1, animationId2, flashStatus;
    if (isset(options) && options === Object(options)) {
      $flash = void 0;
      if (!isset(options.id)) {
        $flash = $('<div/>').attr('id', 'flash' + Date.now()).attr('class', 'flash');
      } else {
        $flash = $('#' + options.id);
      }
      flashStatus = $flash.hasClass('flash-opened');
      if (isset(options.style)) {
        $flash.attr('class', 'flash ' + options.style);
      } else {
        $flash.attr('class', 'flash');
      }
      options.timeout = isset(options.timeout) ? options.timeout : 3000;
      if (isset(options.content)) {
        if ($flash.find('.flash-content').length) {
          $flash.find('.flash-content').text(options.content);
        } else {
          $flash.prepend('<span class=flash-content>' + options.content + '</span>');
        }
      }
      if (!isset(options.id)) {
        $flash.appendTo('#flash-container');
      } else {
        $flash.insertAfter('#flash-container .flash:last-child');
      }
      if (isset(options.action) && options.action === 'toggle') {
        if (flashStatus) {
          options.action = 'hide';
        } else {
          options.action = 'show';
        }
      }
      animationId1 = Date.now();
      $flash.data('animationId1', animationId1);
      setTimeout((function() {
        if ($flash.data('animationId1') === animationId1) {
          if (!isset(options.action) || options.action === 'show') {
            $flash.addClass('flash-opened');
          } else if (isset(options.action) && options.action === 'hide') {
            $flash.removeClass('flash-opened');
          }
        }
      }), 50);
      animationId2 = Date.now();
      $flash.data('animationId2', animationId2);
      if (options.timeout !== 0) {
        setTimeout((function() {
          if ($flash.data('animationId2') === animationId2) {
            $flash.removeClass('flash-opened');
          }
        }), options.timeout);
      }
      return $flash;
    } else {
      return false;
    }
  };
  $.fn.flash = function(action) {
    var $flash, options;
    options = {};
    if (!this.hasClass('flash')) {
      if (!isset(action) || action === 'show' || action === 'hide' || action === 'toggle') {
        options = {
          content: $(this).attr('data-content'),
          style: $(this).attr('data-style'),
          timeout: $(this).attr('data-timeout')
        };
      }
      if (isset(action)) {
        options.id = this.attr('data-flash-id');
        if (action === 'show' || action === 'hide' || action === 'toggle') {
          options.action = action;
        }
      }
      $flash = $.flash(options);
      this.attr('data-flash-id', $flash.attr('id'));
      return $flash;
    } else {
      options.id = this.attr('id');
      if (action === 'show' || action === 'hide' || action === 'toggle') {
        options.action = action;
      }
      return $.flash(options);
    }
  };
})(jQuery);
