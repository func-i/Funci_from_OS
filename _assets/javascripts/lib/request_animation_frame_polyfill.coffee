(->
  lastTime = 0
  vendors = ["ms", "moz", "webkit", "o"]
  i = 0

  while i < vendors.length and not window.requestAnimationFrame
    window.requestAnimationFrame = window[vendors[i] + "RequestAnimationFrame"]
    window.cancelAnimationFrame = window[vendors[i] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
    ++i
  unless window.requestAnimationFrame
    window.requestAnimationFrame = (callback, element) ->
      currTime = new Date().getTime()
      timeToCall = Math.max(0, 16 - (currTime - lastTime))
      id = window.setTimeout ->
        callback currTime + timeToCall
      timeToCall
      lastTime = currTime + timeToCall
      id
  unless window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
      clearTimeout id
)()