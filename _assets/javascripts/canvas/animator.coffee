@animationIds = []

@animateLogo = (logo, canvas, context) ->
  context.clear 0, 0, canvas.width, canvas.height
  logo.draw()

  # continue animation
  animationId = requestAnimationFrame -> animateLogo(logo, canvas, context)
  # save animation for easy cancelation
  animationIds.push animationId

@animateSquare = (square, canvas, context) ->
  context.clear square.left, square.top, square.sideLength, square.sideLength
  square.draw()

  animationId = requestAnimationFrame -> animateSquare(square, canvas, context)
  animationIds.push animationId

@animateAllSquares = (canvas, context) ->
  context.clear 0, 0, canvas.width, canvas.height
  for square in squares
    square.orient()
    square.draw()

  animationId = requestAnimationFrame -> animateAllSquares(canvas, context)
  animationIds.push animationId

@stopAnimations = ->
  for id in animationIds
    cancelAnimationFrame(id)
  animationIds.length = 0