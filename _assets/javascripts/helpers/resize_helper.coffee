@ResizeHelper =
  handleResize: (args) ->
    logo    = args.logo
    canvas  = args.canvas
    context = args.context

    # continue if still resizing
    clearTimeout resizingTimeoutId

    $('.square').each ->
      $(this).css 'height', $(this).outerWidth()

    SquareHelper.startAnimation canvas, context

    if blendingSupported
      logo.resize $(window).innerWidth()
      LogoHelper.startAnimation logo

      logo.canvas.orient $('body').width(), $('body').height()
      logo.context.setMultiply()

    canvas.orient $('body').width(), $('body').height()
    context.setMultiply()

    # haven't resized in 300ms!
    resizingTimeoutId = setTimeout ->
      stopAnimations()
    , 200 