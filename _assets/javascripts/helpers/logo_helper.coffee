@LogoHelper =
  startAnimation: (logo) ->
    animationId = requestAnimationFrame -> animateLogo(logo, logo.canvas, logo.context)
    animationIds.push animationId

  noTouch:
    mouseover: (logo) ->
      LogoHelper.startAnimation(logo)

    mouseout: (logo) ->
      logo.returnHome()
      setTimeout ->
        stopAnimations()
      , 100

    mousemove: (logo, ev) ->
      mouseX = ev.pageX
      mouseY = ev.pageY
      if logo.expanded
        logo.animate mouseX, mouseY
      logo.changeCursor mouseX, mouseY

    mousedown: (args) ->
      logo     = args.logo
      mouseX   = args.ev.pageX
      mouseY   = args.ev.pageY
      onHome   = args.onHome

      if logo.isUnderMouse mouseX, mouseY
        wasExpanded = logo.expanded
        logo.expand()
        logo.explode mouseX, mouseY
        logo.elem.mouseup ->
          window.location.replace "/" if !onHome
          if wasExpanded then logo.contract() else logo.expand()
          logo.reset()
          logo.elem.unbind 'mouseup'

  touch:
    tap: (args) ->
      logo     = args.logo
      mouseX   = args.ev.gesture.touches[0].pageX
      mouseY   = args.ev.gesture.touches[0].pageY
      onHome   = args.onHome

      if logo.isUnderMouse mouseX, mouseY
        wasExpanded = logo.expanded
        logo.expand()
        logo.explode mouseX, mouseY
        setTimeout ->
          window.location.replace("/") unless onHome
          if wasExpanded then logo.contract() else logo.expand()
          logo.reset()
        , 100

    drag: (args) ->
      logo   = args.logo
      ev     = args.ev
      mouseX = args.ev.gesture.touches[0].pageX
      mouseY = args.ev.gesture.touches[0].pageY
      hold   = args.hold

      if logo.holding
        logo.dragLetters hold, mouseX, mouseY
      else
        logo.animate mouseX, mouseY

      ev.gesture.preventDefault() if logo.isUnderMouse(mouseX, mouseY)