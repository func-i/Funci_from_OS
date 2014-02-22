$ ->
  $nav = $('.touch header nav')

  unless $nav.length is 0

    $nav.find('a.has-menu').click (ev) ->
      ev.stopPropagation()

      $clickedA = $(this)
      $clickedLi = $clickedA.closest('li')
      $otherLis = $clickedLi.siblings()

      $nav.find('li.menu-activated').removeClass('menu-activated')
      $nav.find('a.navigable').removeClass('navigable')

      if $clickedA.hasClass('navigable')
        # navigate like usual
      else
        ev.preventDefault()
        $clickedLi.addClass('menu-activated')
        $clickedA.addClass('navigable')

    $('.touch #body').click ->
      $nav.find('li.menu-activated').removeClass('menu-activated')
      $nav.find('a.navigable').removeClass('navigable')