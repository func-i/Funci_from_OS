class SceneSet
  UP_KEY: 38
  DOWN_KEY: 40
  SCENE_TRANSITION_CLASS: 'fade-out'
  SCENE_HIDDEN_CLASS: 'hidden'
  ARROW_TRANSITION_CLASS: 'fade-out'
  ARROW_HIDDEN_CLASS: 'hidden'
  
  previousScrollDelta: 0
  isScrolling: false
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
    },
    {
      final_scroll_value: 1.0,
      start_clear_color: BASE_COLORS.white,
      end_clear_color: BASE_COLORS.white,
      arrow_data_color: "yellow"
    }
  ]
  
  init: () ->
    @scenes = $('.cube-scene')
    @arrows = $('.cube-scene-arrow')
    @scenesWrapper = $('#cube-scenes')
    # Have to remove the padding we normally leave for the footer, since here our footer is inline
    $('#body').css('padding-bottom', 0)
    ResizeHelper.resizeIndex()
    ResizeHelper.resizeScenes(@scenes)
  
  #----------------- STATE CHECKING FUNCTIONS -----------------
  canScroll: (sceneDelta) ->
    !@isScrolling && @nextSceneIsWithinSet(sceneDelta) && ResizeHelper.isDesktopSized()
  
  shouldCubesRotate: (sceneDelta) ->
    @sceneIndex is 0 || (@sceneIndex is 1 && sceneDelta > 0)
  
  nextSceneIsWithinSet: (sceneDelta) ->
    (sceneDelta > 0 && @sceneIndex < @scenes.length - 1) || (sceneDelta < 0 && @sceneIndex > 0)
  
  #----------------- SCENE CHANGE FUNCTIONS -----------------
  # The function decides how to change the scenes
  switchScene: (sceneDelta) ->
    if (@canScroll(sceneDelta) && !@cubes.isScrolling)
      @isScrolling = true
      $scene = @currentScene()
      @sceneIndex += sceneDelta
      @hideOrShowArrows(@sceneIndex)
      
      if @shouldCubesRotate(sceneDelta)
        # In this case, we're going to 
        # 1. Fade out current scene
        # 2. The opacity transition end will trigger the scrollToScene and fade in (through event callbacks)
        @hideScene($scene)
        @cubes.onScroll(@sceneIndex, sceneDelta)
      else
        # In this case, we're going to
        # 1. Scroll to the next scene (everything is already opaque at this point)
        @scrollToScene()
      
  showScene: ($scene) ->
    $scene.removeClass(@SCENE_TRANSITION_CLASS)
    
  hideScene: ($scene) ->
    $scene.addClass(@SCENE_TRANSITION_CLASS)
  
  scrollToScene: () ->
    # Our resize helper assumes that the scenes are the same height as the window.innerHeight!
    ResizeHelper.applySceneTransform(@sceneIndex)
  
  
  # ----------------- EVENT LISTENERS -----------------
  onSceneTranslationEnd: (event) ->
    # After translation, allow scrolling again
    @isScrolling = false
    
  onSceneTransitionEnd: (event) ->
    event.stopPropagation()
    $scene = $(event.target)
    # If our scene is the one fading out (ie not the current scene) then scroll to next
    if ($scene.hasClass(@SCENE_TRANSITION_CLASS))
      scene = @currentScene()
      @showScene(scene)
      @scrollToScene(scene)

  onScroll: (event) ->
    scrollDelta = event.deltaY
    scrollAcceleration = Math.abs(scrollDelta) - Math.abs(@previousScrollDelta)
    
    sceneDelta = Math.sign(scrollDelta)
    # Only trigger scroll if scroll acceleration is positive!
    # This helps us deal with the OSX touchpad inertia
    if sceneDelta != 0 && scrollAcceleration > 0
      @switchScene(sceneDelta)
      
    @previousScrollDelta = scrollDelta
    
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
  
  bindEvents: () ->
    @scenes.on("transitionend", @onSceneTransitionEnd.bind(@))
    @scenesWrapper.on("transitionend", @onSceneTranslationEnd.bind(@))
    window.addEventListener('mousewheel', @onScroll.bind(@))
    window.addEventListener('keyup', @onKeyPress.bind(@))
    @arrows.on('click', @onArrowClick.bind(@))

  #----------------- UTILITY -----------------
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

  setupWebGLCubes: (onLoadCallback) ->
    @cubes = new Cubes(@sceneInfo)
    @cubes.setOnLoad(onLoadCallback)
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
    sceneSet.setupWebGLCubes(LoadingHelper.fadeIn)
