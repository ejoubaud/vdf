# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require html5shiv
#= require jquery
#= require jquery_ujs
#= require bootstrap-scrollspy

# Fixes navbar when overscrolled
# Cares about resizing
fixNavBarOnOverscroll = (navSelector = '.body-nav', fixedClass = 'fixed-nav', container = window) ->

  $win = $(container)
  $nav = $(navSelector)
  offsetParent = $nav.offsetParent()
  navPosition = 0
  fixed = false
  # Original navbar offset from document top, when not fixed
  navOffset = 0

  updateNavOffset = ->
    # If nav is fixed already, jQuery can't know its original offset
    # so we calculate it from "updated parent absolute offset + last known navbar relative position from parent"
    navPosition = $nav.position().top unless fixed
    navOffset = offsetParent.offset().top + navPosition

  watchOverscroll = ->
    if !fixed && navOffset < $win.scrollTop() 
      $nav.addClass fixedClass
      fixed = true
    else if fixed && navOffset >= $win.scrollTop()
      $nav.removeClass fixedClass
      fixed = false

  updateNavOffset()
  watchOverscroll()

  # from Bootstrap demo code : hack sad times - holdover until rewrite for 2.1
  $nav.on 'click', ->
    setTimeout watchOverscroll, 10


  $win.on 'scroll', watchOverscroll
  # nav offset is updated only on resize
  $win.on 'resize', -> updateNavOffset(); watchOverscroll()


$ -> fixNavBarOnOverscroll()
