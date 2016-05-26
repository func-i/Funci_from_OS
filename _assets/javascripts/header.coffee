$ ->
  $body = $('#body')
  $nav  = $('.touch header nav')
  bodyDOM = document.querySelector('body')
  unless $nav.length is 0
    menuActivated = false

    $nav.find('a.has-menu').click (ev) ->
      ev.stopPropagation()

      $clickedA = $(this)
      $clickedLi = $clickedA.closest('li')
      $otherLis = $clickedLi.siblings()
      $otherAs = $otherLis.find('>a')

      unless $clickedA.hasClass('navigable')
        ev.preventDefault()
        $clickedLi.addClass('menu-activated')
        $clickedA.addClass('navigable')
        $otherLis.removeClass('menu-activated')
        $otherAs.removeClass('navigable')

      menuActivated = true

    $('.touch #body').click (ev) ->
      unless $(this).closest('.sub-menu').length
        if menuActivated
          $nav.find('li.menu-activated').removeClass('menu-activated')
          $nav.find('a.navigable').removeClass('navigable')
  
  $(document).scroll (ev) ->
    distanceTop = bodyDOM.getBoundingClientRect().top
    if (distanceTop < 0)
      $('nav').addClass('hidden')
      $(this).unbind(ev)
  
  $('.nav-hover-container').on "mouseenter", (ev) ->
    $('nav').removeClass('hidden')
  
  $navHoverContainer = $('.nav-hover-container')
    
  $navHoverContainer.on "mouseleave", (ev) ->
    width = $navHoverContainer.outerWidth()
    height = $navHoverContainer.outerHeight()
    if ev.clientX > width || ev.clientY > height
      $('nav').addClass('hidden')
    
  $navMenu = $('.nav-menu')
      
  $('.nav-menu > li > a').click (ev) ->
    $menuLink = $(ev.target)
    if $menuLink.hasClass('has-menu')
      if $menuLink.hasClass('active')
        debugger
      else
        ev.preventDefault()
        ev.stopPropagation()
        $subMenu = $menuLink.siblings()
        $navMenu.addClass('sub-menu-active')
        width = $navMenu.outerWidth();
        $navMenu.css('width', width)
        $menuLink.parent().addClass('active')
        $subMenu.addClass('active')
  #     
  # $('.nav-back-button').click (ev) ->
  #   $subMenu = $(ev.target).parent();
  #   debugger
  #   $subMenu.addClass('hidden')
  #   $navMenu.removeClass('hidden')
