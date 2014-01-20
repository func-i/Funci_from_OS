@ResizeHelper =
  handleResize: (args) ->
    logo    = args.logo
    canvas  = args.canvas
    context = args.context

    $('.square').each ->
      $(this).css 'height', $(this).outerWidth()

    canvas.orient $('body').width(), $('body').height()
    context.clear 0, 0, canvas.width, canvas.height
    context.setMultiply()

    for square in squares
      square.orient()
      square.draw()

    if blendingSupported
      logo.canvas.orient $('body').width(), $('body').height()
      logo.context.clear 0, 0, canvas.width, canvas.height
      logo.context.setMultiply()

      logo.resize $(window).innerWidth()
      logo.draw()

  windowOrientation: undefined