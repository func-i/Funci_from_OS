class SceneSet
  UP_KEY: 38
  DOWN_KEY: 40
  SCENE_TRANSITION_CLASS: 'fade-out'
  SCENE_HIDDEN_CLASS: 'hidden'
  ARROW_TRANSITION_CLASS: 'fade-out'
  ARROW_HIDDEN_CLASS: 'hidden'
  sceneIndex: 0
  sceneInfo: [
    { 
      final_scroll_value: 0.5,
      start_clear_color: BASE_COLORS.white,
      end_clear_color: BASE_COLORS.darkGray,
      arrow_data_color: "white"
    },
    {
      final_scroll_value: 1.0,
      start_clear_color: BASE_COLORS.white,
      end_clear_color: BASE_COLORS.white,
      arrow_data_color: "yellow"
      },
    {
      final_scroll_value: 0.5,
      start_clear_color: BASE_COLORS.white,
      end_clear_color: BASE_COLORS.darkGray,
      arrow_data_color: "white"
    }
  ]
  
  init: () ->
    @scenes = $('.cubes-scene')
    @arrows = $('.cubes-scene-arrow')
    # Not sure how to handle other layout problems, perhaps just use a different layout?
    $footer = $('footer')
    $footer.css('display', 'none')
    $(body).css('padding', 0)

    ResizeHelper.resizeScenes(@scenes)
  
  canScroll: (sceneDelta) ->
    (sceneDelta > 0 && @sceneIndex < @scenes.length - 1) || (sceneDelta < 0 && @sceneIndex > 0)
    
  switchScene: (sceneDelta) ->
    if (@canScroll(sceneDelta) && !@cubes.isScrolling)
      @cubes.onScroll(sceneDelta)
      $scene = @currentScene()
      $scene.css('transition-duration', .5 * @cubes.getScrollDurationInSeconds() + 's')
      @hideScene($scene)
      @sceneIndex += sceneDelta
      @hideOrShowArrows(@sceneIndex)
  
  showScene: ($scene) ->
    $scene.removeClass(@SCENE_HIDDEN_CLASS)
    $scene.removeClass(@SCENE_TRANSITION_CLASS)
    
  hideScene: ($scene) ->
    $scene.addClass(@SCENE_TRANSITION_CLASS)
  
  onSceneTransitionEnd: (event) ->
    $scene = $(event.target)
    if ($scene.hasClass(@SCENE_TRANSITION_CLASS))
      $scene.addClass(@SCENE_HIDDEN_CLASS)
      @showScene(@currentScene())

  onScroll: (event) ->      
    @switchScene(Math.sign(event.deltaY))
    
  onKeyPress: (event) ->
    keynum = event.keyCode
    if (keynum is @UP_KEY)
      sceneDelta = -1
    else if (keynum is @DOWN_KEY)
      sceneDelta = 1
    else
      return
    @switchScene(sceneDelta)
  
  onArrowClick: (event) ->
    direction = $(event.target).parent().data('direction')
    event.preventDefault()
    if (direction is "up")
      sceneDelta = -1
    else if (direction is "down")
      sceneDelta = 1
    @switchScene(sceneDelta)
  
  
  hideOrShowArrows: () ->
    arrowToHide = false
    #Show all arrows
    @arrows.removeClass(@ARROW_HIDDEN_CLASS)
    
    #Hide the top or bottom if required
    if (@sceneIndex is 0)
      arrowToHide = @arrows.eq(0)
    else if (@sceneIndex is @scenes.length - 1)
      arrowToHide = @arrows.eq(1)
    
    if (!!arrowToHide)
      arrowToHide.addClass(@ARROW_HIDDEN_CLASS)
    
    #make the arrows the right color;
    @arrows.attr('data-color', @sceneInfo[@sceneIndex].arrow_data_color)
    
  bindEvents: () ->
    @scenes.on("transitionend", @onSceneTransitionEnd.bind(@))
    window.addEventListener('mousewheel', @onScroll.bind(@))
    window.addEventListener('keyup', @onKeyPress.bind(@))
    @arrows.on('click', @onArrowClick.bind(@))

  setupWebGLCubes: () ->
    @cubes = new Cubes(@sceneInfo)
    @cubes.setOnLoad(LoadingHelper.fadeIn)
    @cubes.loadAndInitialize()
    @bindEvents()

  currentScene: () ->
    @scenes.eq(@sceneIndex)
    
  currentSceneInfo: () ->
    @sceneInfo[@sceneIndex]

$ ->
  if ($('#index').length < 1)
    LoadingHelper.fadeIn();
    return
  else
    sceneSet = new SceneSet()
    sceneSet.init()
    sceneSet.setupWebGLCubes()
