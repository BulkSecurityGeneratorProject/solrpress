### ========================================================================
# Bootstrap: sidebar.js v0.1
# ========================================================================
# Copyright 2011-2014 Asyraf Abdul Rahman
# Licensed under MIT
# ======================================================================== 
###

+(($) ->
  'use strict'
  # SIDEBAR PUBLIC CLASS DEFINITION
  # ================================

  Sidebar = (element, options) ->
    @$element = $(element)
    @options = $.extend({}, Sidebar.DEFAULTS, options)
    @transitioning = null
    if @options.parent
      @$parent = $(@options.parent)
    if @options.toggle
      @toggle()
    return

  Sidebar.DEFAULTS = toggle: true

  Sidebar::show = ->
    if @transitioning or @$element.hasClass('sidebar-open')
      return
    startEvent = $.Event('show.bs.sidebar')
    @$element.trigger startEvent
    if startEvent.isDefaultPrevented()
      return
    @$element.addClass 'sidebar-open'
    @transitioning = 1

    complete = ->
      @$element
      @transitioning = 0
      @$element.trigger 'shown.bs.sidebar'
      return

    if !$.support.transition
      return complete.call(this)
    @$element.one($.support.transition.end, $.proxy(complete, this)).emulateTransitionEnd 400
    return

  Sidebar::hide = ->
    if @transitioning or !@$element.hasClass('sidebar-open')
      return
    startEvent = $.Event('hide.bs.sidebar')
    @$element.trigger startEvent
    if startEvent.isDefaultPrevented()
      return
    @$element.removeClass 'sidebar-open'
    @transitioning = 1

    complete = ->
      @transitioning = 0
      @$element.trigger 'hidden.bs.sidebar'
      return

    if !$.support.transition
      return complete.call(this)
    @$element.one($.support.transition.end, $.proxy(complete, this)).emulateTransitionEnd 400
    return

  Sidebar::toggle = ->
    @[if @$element.hasClass('sidebar-open') then 'hide' else 'show']()
    return

  old = $.fn.sidebar

  $.fn.sidebar = (option) ->
    @each ->
      $this = $(this)
      data = $this.data('bs.sidebar')
      options = $.extend({}, Sidebar.DEFAULTS, $this.data(), typeof options == 'object' and option)
      if !data and options.toggle and option == 'show'
        option = !option
      if !data
        $this.data 'bs.sidebar', data = new Sidebar(this, options)
      if typeof option == 'string'
        data[option]()
      return

  $.fn.sidebar.Constructor = Sidebar

  $.fn.sidebar.noConflict = ->
    $.fn.sidebar = old
    this

  $(document).on 'click.bs.sidebar.data-api', '[data-toggle="sidebar"]', (e) ->
    $this = $(this)
    href = undefined
    target = $this.attr('data-target') or e.preventDefault() or (href = $this.attr('href')) and href.replace(/.*(?=#[^\s]+$)/, '')
    $target = $(target)
    data = $target.data('bs.sidebar')
    option = if data then 'toggle' else $this.data()
    $target.sidebar option
    return
  $('html').on 'click.bs.sidebar.autohide', (event) ->
    $this = $(event.target)
    isButtonOrSidebar = $this.is('.sidebar, [data-toggle="sidebar"]') or $this.parents('.sidebar, [data-toggle="sidebar"]').length
    if isButtonOrSidebar
      return
    else
      $target = $('.sidebar')
      $target.each (i, trgt) ->
        $trgt = $(trgt)
        if $trgt.data('bs.sidebar') and $trgt.hasClass('sidebar-open')
          $trgt.sidebar 'hide'
        return
    return
  return
)(jQuery)
