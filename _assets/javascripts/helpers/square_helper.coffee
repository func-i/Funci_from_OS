@SquareHelper =
  windowOrientation: undefined  

  startAnimation: (canvas, context) ->
    animationId = requestAnimationFrame -> animateAllSquares(canvas, context)
    animationIds.push animationId