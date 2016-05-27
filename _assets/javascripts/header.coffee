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
    
  
  
  toggleActive = ($menuLink, shouldBeActive) ->
    $menuItem = $menuLink.parent()
    $subMenu = $menuLink.siblings()
    if shouldBeActive
      width = $navMenu.outerWidth();
      $navMenu.addClass('sub-menu-active')
      $navMenu.css('width', width * 1.01)
      $menuItem.addClass('active')
      $subMenu.addClass('active')
    else
      $navMenu.removeClass('sub-menu-active')
      setTimeout(() -> 
        $navMenu.css('width', '')
      , 400)
      $menuItem.removeClass('active')
      $subMenu.removeClass('active')

  $navMenu = $('.nav-menu')    
  $('.nav-menu > li > a').click (ev) ->
    $menuLink = $(ev.target)
    if $menuLink.hasClass('has-menu')
      ev.preventDefault()
      ev.stopPropagation()
      toggleActive($menuLink, !$menuLink.parent().hasClass('active'))

  # $('.nav-back-button').click (ev) ->
  #   $subMenu = $(ev.target).parent();
  #   debugger
  #   $subMenu.addClass('hidden')
  #   $navMenu.removeClass('hidden')
