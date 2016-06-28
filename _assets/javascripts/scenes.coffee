SCENE_TRANSITION_CLASS = 'fade-out'
SCENE_HIDDEN_CLASS = 'hidden'

$ ->
  if ($('#index').length < 1)
    return
  # Find all the scenes
  $scenes = $('.cubes-scene')
  
  # Not sure how to handle other layout problems, perhaps just use a different layout?
  $footer = $('footer')
  $footer.css('display', 'none')
  $(body).css('padding', 0)
  
  $scenes.each((index, scene) ->
    $scene = $(scene)
    # Set size of each scene to window height
    $scene.css('height', window.innerHeight)
    # # Hide all but the first scene
    # if (index > 0)
    #   $scene.addClass(SCENE_HIDDEN_CLASS)
    #   $scene.addClass(SCENE_TRANSITION_CLASS)
  )

  # Initialize cubies
  sceneIndex = 0
  cubeSceneInfo = [
    { final_scroll_value: 0.5 },
    { final_scroll_value: 1.0 },
    { final_scroll_value: 0.5 }
  ]
  
  # Add listeners for scroll, etc. (that also kick off cubie functions)
  canScroll = (sceneDelta) ->
    (sceneDelta > 0 && sceneIndex < $scenes.length - 1) || (sceneDelta < 0 && sceneIndex > 0)
    
  switchScene = (sceneDelta) ->
    if (canScroll(sceneDelta))
      $scene = $scenes.eq(sceneIndex)
      $scene.css('transition-duration', cubes.getScrollDurationInSeconds() + 's')
      hideScene($scene)
      sceneIndex += sceneDelta
  
  showScene = ($scene) ->
    $scene.removeClass(SCENE_HIDDEN_CLASS)
    $scene.removeClass(SCENE_TRANSITION_CLASS)
    
  hideScene = ($scene) ->
    $scene.addClass(SCENE_TRANSITION_CLASS)
  
  onSceneTransitionEnd = (event) ->
    event.stopPropagation()
    $scene = $(event.target)
    if ($scene.hasClass(SCENE_TRANSITION_CLASS))
      $scene.addClass(SCENE_HIDDEN_CLASS)
      showScene($scenes.eq(sceneIndex))

  $scenes.on("transitionend", onSceneTransitionEnd)
  
  if ($('#webgl-cubes-container').length > 0)    
    cubes = new Cubes(cubeSceneInfo)
    cubes.onLoad()
    window.addEventListener('mousewheel', (event) ->
      if (!cubes.isScrolling)
        sceneDelta = Math.sign(event.deltaY)
        cubes.onScroll(sceneDelta)
        switchScene(sceneDelta)
    )
