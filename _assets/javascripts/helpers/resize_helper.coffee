@ResizeHelper =
  handleResize: (args) ->
    $('.square').each ->
      $square = $(this)
      $square.css 'width', ''
      roundedWidth = Math.round($(this).outerWidth())
      $square.css 'width', roundedWidth
      $square.css 'height', roundedWidth
    
    $squares = $('.square-no-canvas')
    $squares.css 'width', '100%'
    widths = $squares.map ->
      $square = $(this)
      Math.round($square.outerWidth())
    
    $squares.each (i) ->
      $square = $(this)
      $square.css 'width', widths[i]
      $square.css 'height', widths[i]

    console.log(widths)

    $('.square-no-canvas-no-fill').each ->
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