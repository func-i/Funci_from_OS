@ResizeHelper =
  resizeSquares: ($squares) ->
    $squares.css 'width', '100%'
    widths = $squares.map ->
      $square = $(this)
      Math.round($square.outerWidth())    
    $squares.each (i) ->
      $square = $(this)
      $square.css 'width', widths[i]
      $square.css 'height', widths[i]
      
  resizeScenes: ($scenes) ->
    $scenes.each((index, scene) ->
      $scene = $(scene)
      # Set size of each scene to window height
      $scene.css('height', window.innerHeight)
    )

  handleResize: (args) ->
    
    @resizeSquares($('.square'))
    @resizeSquares($('.square-no-canvas'))
    @resizeSquares($('.square-no-canvas-no-fill'))
    
    @resizeScenes($('.cubes-scene'))
    
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