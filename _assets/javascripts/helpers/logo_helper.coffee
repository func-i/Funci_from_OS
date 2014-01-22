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
      if logo.full
        logo.animate mouseX, mouseY
      logo.changeCursor mouseX, mouseY

    mousedown: (args) ->
      logo     = args.logo
      mouseX   = args.ev.pageX
      mouseY   = args.ev.pageY
      onHome   = args.onHome
      onMobile = args.onMobile

      if logo.isUnderMouse mouseX, mouseY
        unless onMobile then logo.explode mouseX, mouseY
        logo.elem.mouseup ->
          args =
            onHome: onHome
            onMobile: onMobile
          logo.handleMouseup args
          logo.reset()
          logo.elem.unbind 'mouseup'

  touch:
    tap: (args) ->
      logo     = args.logo
      mouseX   = args.ev.gesture.center.pageX
      mouseY   = args.ev.gesture.center.pageY
      onHome   = args.onHome
      onMobile = args.onMobile

      if logo.isUnderMouse mouseX, mouseY
        logo.explode mouseX, mouseY unless onMobile 
        window.location.replace("/") unless onHome
        setTimeout ->
          args =
            onHome: onHome
            onMobile: onMobile
          logo.handleMouseup args
        , 100

    drag: (args) ->
      logo   = args.logo
      mouseX = args.ev.gesture.center.pageX
      mouseY = args.ev.gesture.center.pageY
      hold   = args.hold

      if logo.holding
        logo.dragLetters hold, mouseX, mouseY
      else
        logo.animate mouseX, mouseY if logo.full