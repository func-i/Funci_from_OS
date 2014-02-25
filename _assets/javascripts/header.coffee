$ ->
  $body = $('#body')
  $nav  = $('.touch header nav')

  unless $nav.length is 0

    menuActivated = false

    $nav.find('a.has-menu').click (ev) ->
      ev.stopPropagation()

      $clickedA = $(this)
      $clickedLi = $clickedA.closest('li')
      $otherLis = $clickedLi.siblings()
      $otherAs = $otherLis.find('>a')

      if $clickedA.hasClass('navigable')
        # navigate like a boss
      else
        ev.preventDefault()
        $clickedLi.addClass('menu-activated')
        $clickedA.addClass('navigable')
        $otherLis.removeClass('menu-activated')
        $otherAs.removeClass('navigable')

      menuActivated = true

    $('.touch #body').hammer().on 'tap', (ev) ->
      unless $(ev.target).closest('.sub-menu').length
        if menuActivated
          $nav.find('li.menu-activated').removeClass('menu-activated')
          $nav.find('a.navigable').removeClass('navigable')