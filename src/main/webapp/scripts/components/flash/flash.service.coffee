'use strict'

###*
# Created by ferdous on 1/9/15.
###

(($) ->
  isset = undefined

  isset = (variable) ->
    if typeof variable != 'undefined' and variable != null
      true
    else
      false

  $(document).ready ->
    $('body').append '<div id=flash-container/>'
    return
  $(document).on('click', '[data-toggle=flash]', ->
    $(this).flash 'toggle'
    return
  ).on 'click', '#flash-container .flash', ->
    $(this).flash 'hide'
    return

  $.flash = (options) ->
    $flash = undefined
    animationId1 = undefined
    animationId2 = undefined
    flashStatus = undefined
    if isset(options) and options == Object(options)
      $flash = undefined
      if !isset(options.id)
        $flash = $('<div/>').attr('id', 'flash' + Date.now()).attr('class', 'flash')
      else
        $flash = $('#' + options.id)
      flashStatus = $flash.hasClass('flash-opened')
      if isset(options.style)
        $flash.attr 'class', 'flash ' + options.style
      else
        $flash.attr 'class', 'flash'
      options.timeout = if isset(options.timeout) then options.timeout else 3000
      if isset(options.content)
        if $flash.find('.flash-content').length
          $flash.find('.flash-content').text options.content
        else
          $flash.prepend '<span class=flash-content>' + options.content + '</span>'
      if !isset(options.id)
        $flash.appendTo '#flash-container'
      else
        $flash.insertAfter '#flash-container .flash:last-child'
      if isset(options.action) and options.action == 'toggle'
        if flashStatus
          options.action = 'hide'
        else
          options.action = 'show'
      animationId1 = Date.now()
      $flash.data 'animationId1', animationId1
      setTimeout (->
        if $flash.data('animationId1') == animationId1
          if !isset(options.action) or options.action == 'show'
            $flash.addClass 'flash-opened'
          else if isset(options.action) and options.action == 'hide'
            $flash.removeClass 'flash-opened'
        return
      ), 50
      animationId2 = Date.now()
      $flash.data 'animationId2', animationId2
      if options.timeout != 0
        setTimeout (->
          if $flash.data('animationId2') == animationId2
            $flash.removeClass 'flash-opened'
          return
        ), options.timeout
      $flash
    else
      false

  $.fn.flash = (action) ->
    $flash = undefined
    options = undefined
    options = {}
    if !@hasClass('flash')
      if !isset(action) or action == 'show' or action == 'hide' or action == 'toggle'
        options =
          content: $(this).attr('data-content')
          style: $(this).attr('data-style')
          timeout: $(this).attr('data-timeout')
      if isset(action)
        options.id = @attr('data-flash-id')
        if action == 'show' or action == 'hide' or action == 'toggle'
          options.action = action
      $flash = $.flash(options)
      @attr 'data-flash-id', $flash.attr('id')
      $flash
    else
      options.id = @attr('id')
      if action == 'show' or action == 'hide' or action == 'toggle'
        options.action = action
      $.flash options

  return
) jQuery
