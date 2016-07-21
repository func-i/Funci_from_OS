class SceneSet
  UP_KEY: 38
  DOWN_KEY: 40
  SCENE_TRANSITION_CLASS: 'fade-out'
  SCENE_HIDDEN_CLASS: 'hidden'
  ARROW_TRANSITION_CLASS: 'fade-out'
  ARROW_HIDDEN_CLASS: 'hidden'
  
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
  switchScene: (sceneDelta) ->
    if (@canScroll(sceneDelta) && !@cubes.isScrolling)
      @isScrolling = true
      $scene = @currentScene()
      $scene.css('transition-duration', .5 * @cubes.getScrollDurationInSeconds() + 's')
      @sceneIndex += sceneDelta
      @hideOrShowArrows(@sceneIndex)
      
      if @shouldCubesRotate(sceneDelta)
        # In this case, we're going to
        # 1. Fade out current scene
        # 2. The opacity transition end will trigger the scrollToScene
        # 3. The transform transition end will trigger the fade-in of next scene
        @hideScene($scene)
        @cubes.onScroll(@sceneIndex, sceneDelta)
      else
        # In this case, we're going to
        # 1. Scroll to the next scene (everything is already opaque at this point)
        @scrollToScene(@currentScene())
      
  showScene: ($scene) ->
    $scene.removeClass(@SCENE_TRANSITION_CLASS)
    
  hideScene: ($scene) ->
    $scene.addClass(@SCENE_TRANSITION_CLASS)
  
  scrollToScene: ($scene) ->
    # Apply transform takes the DELTA, ie the difference 
    # between current translation and new translation
    ResizeHelper.applySceneTransform(-1 * $scene.offset().top)
  
  
  # ----------------- EVENT LISTENERS -----------------
  onSceneTranslationEnd: (event) ->
    # After translation, fade in current scene
    @showScene(@currentScene())
    @isScrolling = false
    
  onSceneTransitionEnd: (event) ->
    $scene = $(event.target)
    # If our scene is the one fading out (ie not the current scene) then scroll to next
    if ($scene.hasClass(@SCENE_TRANSITION_CLASS))
      @scrollToScene(@currentScene())

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
