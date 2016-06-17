@ResizeHelper =
  handleResize: (args) ->
    $('.square').each ->
      $square = $(this)
      $square.css 'width', ''
      roundedWidth = Math.round($(this).outerWidth())
      $square.css 'width', roundedWidth
      $square.css 'height', roundedWidth
    
    $('.square-no-canvas').each ->
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

  windowOrientation: undefined