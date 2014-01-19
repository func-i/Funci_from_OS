class @Pinch
  distanceLowerBound: 20

  constructor: (args) ->
    @initDistance = @getDistance(args.center, args.rawTouches[0].pageX, args.rawTouches[0].pageY)
    @touches = []
    @saveTouches(args.rawTouches, args.center)

  saveTouches: (rawTouches, center) ->
    for rawTouch in rawTouches
      touch =
        id: rawTouch.identifier
      @touches.push touch

  getDistance: (center, touchPosX, touchPosY) ->
    distanceX = center.pageX - touchPosX
    distanceY = center.pageY - touchPosY
    return Math.round(Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2)))

  multiplier: ->
    return ((@initDistance - @distance) / @initDistance).toFixed(2)

  updatePosition: (center, rawTouches) ->
    @center = center
    for rawTouch in rawTouches
      touch = _.findWhere(@touches, {id: rawTouch.identifier})
      touch.position =
        left: rawTouch.pageX
        top: rawTouch.pageY
    @distance = @getDistance(@center, rawTouches[0].pageX, rawTouches[0].pageY)