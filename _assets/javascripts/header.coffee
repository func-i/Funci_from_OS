$ ->
  $body = $('#body')
  $nav  = $('.touch header nav')
  $navMenu = $('.nav-menu')    
  bodyDOM = document.querySelector('body')
  $navHoverContainer = $('.nav-hover-container')
  
  # Need a set width for when we switch to nav-sub-menus (since they are 
  # positioned absolutely)
  
  
  $(document).scroll (ev) ->
    distanceTop = bodyDOM.getBoundingClientRect().top
    if (distanceTop < 0)
      $('nav').addClass('hidden')
      $(this).unbind(ev)
  
  # This is to prevent the cubies from rotating behind the header text
  $navMenu.on "mousemove", (ev) ->
    ev.stopPropagation()
    
  $('.nav-logo-container').children().on "mousemove", (ev) ->
    ev.stopPropagation()
  
  $navHoverContainer.on "mouseenter", (ev) ->
    $('nav').removeClass('hidden')
  
  $navHoverContainer.on "mouseleave", (ev) ->
    width = $navHoverContainer.outerWidth()
    height = $navHoverContainer.outerHeight()
    if ev.clientX > width || ev.clientY > height
      $('nav').addClass('hidden')
  
  toggleActive = ($menuLink, shouldBeActive) ->
    $menuItem = $menuLink.parent()
    $subMenu = $menuLink.siblings()
    if shouldBeActive
      $navMenu.addClass('nav-sub-menu-active')
      $menuItem.addClass('active')
      $subMenu.addClass('active')
      ResizeHelper.resizeNav($menuLink)
    else
      $navMenu.removeClass('nav-sub-menu-active')
      setTimeout(() -> 
        $navMenu.css('width', '')
      , 400)
      $menuItem.removeClass('active')
      $subMenu.removeClass('active')
  
  $('.nav-menu-item-link').click (ev) ->
    $menuLink = $(ev.target)
    if $menuLink.hasClass('has-nav-sub-menu')
      ev.preventDefault()
      ev.stopPropagation()
      toggleActive($menuLink, !$menuLink.parent().hasClass('active'))
