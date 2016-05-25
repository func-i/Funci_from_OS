$ ->
  $body = $('#body')
  $nav  = $('.touch header nav')
  bodyDOM = document.querySelector('body');
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
    if (distanceTop < 0) &&
      $('nav').addClass('hidden');
    else
      $('nav').removeClass('hidden');
  
  $('nav').on "mouseenter", (ev) ->
    $('nav').removeClass('hidden');