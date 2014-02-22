$ ->
  $hasMany       = $('.touch header nav a.has-menu')
  $touchBody     = $('.touch #body')
  $menuActivated = $('.touch header nav li.menu-activated')
  $navigable     = $('.touch header nav a.navigable')


  $hasMany.click (ev) ->
    ev.stopPropagation()

    $clickedA = $(this)
    $clickedLi = $clickedA.closest('li')
    $otherLis = $clickedLi.siblings()

    $otherLis.removeClass('menu-activated')

    unless $clickedA.hasClass('navigable')
      ev.preventDefault()
      $clickedLi.addClass('menu-activated')

    $clickedA.toggleClass('navigable')

  $touchBody.click ->
    $menuActivated.removeClass('menu-activated')
    $navigable.removeClass('navigable')