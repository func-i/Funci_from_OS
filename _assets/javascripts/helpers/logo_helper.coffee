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
      if logo.size isnt "twoLetters"
        logo.animate mouseX, mouseY
      logo.changeCursor mouseX, mouseY

    mousedown: (args) ->
      logo     = args.logo
      mouseX   = args.ev.pageX
      mouseY   = args.ev.pageY
      onHome   = args.onHome

      if logo.isUnderMouse mouseX, mouseY
        logo.explode mouseX, mouseY
        logo.elem.mouseup ->
          args =
            onHome: onHome
          logo.handleMouseup args
          logo.reset()
          logo.elem.unbind 'mouseup'

  touch:
    tap: (args) ->
      logo     = args.logo
      mouseX   = args.ev.gesture.touches[0].pageX
      mouseY   = args.ev.gesture.touches[0].pageY
      onHome   = args.onHome

      if logo.isUnderMouse mouseX, mouseY
        logo.explode mouseX, mouseY
        window.location.replace("/") unless onHome
        setTimeout ->
          args =
            onHome: onHome
          logo.handleMouseup args
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
        logo.animate mouseX, mouseY if logo.size isnt "twoLetters"

      ev.gesture.preventDefault() if logo.isUnderMouse(mouseX, mouseY)