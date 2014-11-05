@ResizeHelper =
  handleResize: (args) ->
    $('.square').each ->
      $square = $(this)
      $square.css 'width', ''
      roundedWidth = Math.round($(this).outerWidth())
      $square.css 'width', roundedWidth
      $square.css 'height', roundedWidth

    for canvas in window.canvases
      canvas.orient()
      canvas.context.clear 0, 0, canvas.width, canvas.height
      canvas.context.setMultiply()

      for square in canvas.squares
        square.orient()

      canvas.adjustSquarePositions()
      
      for square in canvas.squares
        square.draw()

    if blendingSupported
      window.logo.canvas.orient $('body').width(), $('body').height()
      window.logo.context.clear 0, 0, logo.canvas.width, logo.canvas.height
      window.logo.context.setMultiply()

      window.logo.resize $(window).innerWidth()
      window.logo.draw()

    lighthouse.positionWithCss()

  windowOrientation: undefined