@SquareHelper =
  windowOrientation: undefined  

  startAnimation: ->
    animationId = requestAnimationFrame -> animateAllSquares(canvas, context)
    animationIds.push animationId

  findSquare: ($elem) ->
    square = $elem.data 'obj'