$ ->
  $body = $('#body')
  $nav  = $('.touch header nav')
  $navMenu = $('.nav-menu')    
  bodyDOM = document.querySelector('body')
  $navHoverContainer = $('.nav-hover-container')
  
  # Need a set width for when we switch to sub-menus (since they are 
  # positioned absolutely)
  
  
  $(document).scroll (ev) ->
    distanceTop = bodyDOM.getBoundingClientRect().top
    if (distanceTop < 0)
      $('nav').addClass('hidden')
      $(this).unbind(ev)
  
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
      $navMenu.css('width', $navMenu.outerWidth() + 1)
      $navMenu.addClass('sub-menu-active')
      $menuItem.addClass('active')
      $subMenu.addClass('active')
    else
      $navMenu.removeClass('sub-menu-active')
      setTimeout(() -> 
        $navMenu.css('width', '')
      , 400)
      $menuItem.removeClass('active')
      $subMenu.removeClass('active')
      
  $('.nav-menu > li > a').click (ev) ->
    $menuLink = $(ev.target)
    if $menuLink.hasClass('has-menu')
      ev.preventDefault()
      ev.stopPropagation()
      toggleActive($menuLink, !$menuLink.parent().hasClass('active'))
