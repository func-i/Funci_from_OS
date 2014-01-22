$ ->
  $('.touch header nav a.has-menu').click (ev) ->
    ev.stopPropagation()

    $clickedA = $(this)
    $clickedLi = $clickedA.closest('li')
    $otherLis = $clickedLi.siblings()

    $otherLis.removeClass('menu-activated')

    unless $clickedA.hasClass('navigable')
      ev.preventDefault()
      $clickedLi.addClass('menu-activated')

    $clickedA.toggleClass('navigable')

  $('.touch body').click ->
    $('header nav li.menu-activated').removeClass('menu-activated')
    $('header nav a.navigable').removeClass('navigable')