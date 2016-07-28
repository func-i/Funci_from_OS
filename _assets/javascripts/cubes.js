"use strict";

var Cubes = function(htmlScenes) {
  this.htmlScenes = htmlScenes;
  this.sceneIndex = 0;
  this.loadingManager = new THREE.LoadingManager();
  this.renderer = new THREE.WebGLRenderer({ antialias: false });
  this.requiredExtensions = ['ANGLE_instanced_arrays', 'OES_texture_float']
  // UTILITY FUNCTIONS

  //This is the entry point, you should call this to kick everything off.
  this.loadAndInitialize = function() {
    var shaderLoader = new ShaderLoader();
    shaderLoader.loadShaders({
      passthrough_vertex: "passthrough/vertex",
      passthrough_fragment: "passthrough/fragment",
      simulation_vertex: "simulation/vertex",
      simulation_fragment : "simulation/fragment",
      scrolling_vertex: "scrolling/vertex",
      scrolling_fragment: "scrolling/fragment",
      cube_vertex: "cubes/vertex",
      cube_fragment: "cubes/fragment",
      scrolling_cube_vertex: "scrolling_cubes/vertex",
      scrolling_cube_fragment: "scrolling_cubes/fragment",
      debug_vertex: "debug/vertex",
      debug_fragment: "debug/fragment"
    }, "/offsite-assets/shaders/", this.init.bind(this) );
  };
  
  this.setUpGui = function() {
    var gui = new dat.GUI();
    this.scroller.addGuiFolder(gui);
    this.waveSim.addGuiFolder(gui);
    
    var folder = gui.addFolder("Cube Wave");
    folder.add(this.waveUniforms.min_angle, 'value', 0.01, 0.5).name("Minimum Angle");
    folder.add(this.waveUniforms.min_speed, 'value', 0.01, 0.5).name("Minimum Speed");
  }
  
  this.checkExtensions = function() {
    extensionsAreSupported = [];
    supportedExtensions = this.renderer.getContext().getSupportedExtensions();
    console.log(supportedExtensions)
    for (var i = 0; i < this.requiredExtensions.length; i++) {
      for (var j = 0; j < supportedExtensions.length; j++) {
        if (this.requiredExtensions[i] === supportedExtensions[j]) {
          extensionsAreSupported[i] = true;
          break;
        }
      }
    }
    return extensionsAreSupported.reduce(function(memo, isSupported) {
      return memo && isSupported;
    });
  }

  this.addDebugPlane = function(scene) {
    var plane = new THREE.PlaneGeometry( this.width/4, this.height/4, 1, 1);
    var planeMaterial = new THREE.RawShaderMaterial({
      uniforms: {
        texture: { type: "t", value: this.waveSim.getCurrentPositionTexture() }
      },
      vertexShader: ShaderLoader.get('debug_vertex'),
      fragmentShader: ShaderLoader.get('debug_fragment'),
      transparent: true
    });
    var planeMesh = new THREE.Mesh( plane, planeMaterial );
    planeMesh.position.z = 2 * this.boxGrid.boxLengthInPixels;
    planeMesh.position.x = this.width/3;
    planeMesh.position.y = this.height/4;
    scene.add( planeMesh );
  }

  // EVENT HANDLERS
  this.addEventListeners = function() {
    window.addEventListener( 'resize', this.onWindowResize.bind(this));  
    window.addEventListener('mousemove', this.onMouseMove.bind(this));  
  };
  
  this.onMouseMove = function(event) {
    if (!this.isScrolling && this.sceneIndex === 0) {
      var mouse = new THREE.Vector2(event.clientX / this.width, 1 - ((event.clientY) / this.height));
      // Need to make it scale properly for arbitrary aspect ratio
      horizontalScaling = Math.min(this.width / this.height / this.boxGrid.columnRowRatio(), 1.0);
      verticalScaling = Math.min(this.height / this.width * this.boxGrid.columnRowRatio(), 1.0);
      mouse.x = mouse.x * horizontalScaling + 0.5 * (1 - horizontalScaling);
      mouse.y = mouse.y * verticalScaling + 0.5 * (1 - verticalScaling);
      this.waveSim.changeMousePosition(mouse);
    }
  };

  this.onScroll = function(sceneIndex, sceneDelta) {
    if (this.isScrolling) return;
    if (sceneIndex - sceneDelta == 0) {
      this.switchToScrollingMaterial();
    }
    this.setScene(sceneIndex, sceneDelta);
  };

  this.onWindowResize = function( event ) {
    this.width = window.innerWidth;
    this.height = window.innerHeight;
    
    this.boxGrid.adjustBoxLengths(this.width, this.height);

    this.scrollingUniforms.boxLength.value = this.boxGrid.boxLengthInPixels;
    this.waveUniforms.boxLength.value = this.boxGrid.boxLengthInPixels;
    
    this.camera.left    = .99 * -.5 * this.width;
    this.camera.right   = .99 *  .5 * this.width;
    this.camera.top     = .99 *  .5 * this.height;
    this.camera.bottom  = .99 * -.5 * this.height;
    this.camera.updateProjectionMatrix();
    
    this.renderer.setSize( this.width, this.height );
    
    if (this.width < SCREEN_WIDTH_UPPER_LIMITS.medium) {
      this.stopAnimating();
    } else if (this.animationID === undefined) {
      this.animate();
    }
  }
  
  this.setOnLoad = function(loadCallback) {
    this.loadingManager.onLoad = loadCallback
  }
  
  // SCROLLING RELATED
  this.setScene = function(sceneIndex, sceneDelta) {
    this.sceneIndex = sceneIndex;
    this.scroller.setFinalScrollValue(this.htmlScenes[this.sceneIndex].final_scroll_value);
    this.renderer.setClearColor(this.htmlScenes[this.sceneIndex].start_clear_color);
    this.setScrollOrigin(sceneDelta);
    this.enableScrolling();
  }

  this.setScrollOrigin = function(sceneDelta) {
    var scrollOriginY = 1 / this.boxGrid.rowCount;
    if (sceneDelta < 0)
      scrollOriginY = 1 - 1 / this.boxGrid.rowCount;
    var scrollOrigin = new THREE.Vector2(0.5, scrollOriginY);
    this.scrollingUniforms.scroll_origin.value = scrollOrigin;
    this.scroller.setSimUniform('scroll_origin', scrollOrigin);
  }
  
  this.switchToWaveMaterial = function() {
    this.mesh.material = this.waveMaterial;
  };
  
  this.switchToScrollingMaterial = function() {
    this.mesh.material = this.scrollingMaterial;
  };

  this.enableScrolling = function() {
    this.isScrolling = true;
  }

  this.disableScrolling = function() {
    this.scroller.setSimUniform('scroll_position', 0)
    this.isScrolling = false;
    this.renderer.setClearColor(this.htmlScenes[this.sceneIndex].end_clear_color);
    if (this.sceneIndex == 0) {
      this.switchToWaveMaterial();
    }
  };
  
  this.getScrollDurationInSeconds = function() {
    return this.scroller.scrollDuration;
  }
  
  // MATERIALS AND UNIFORMS
  
  this.getTexture = function(textureName) {
    var texture = new THREE.TextureLoader(this.loadingManager).load( 'offsite-assets/images/textures/' + textureName );
    texture.magFilter = THREE.NearestFilter;
  	texture.minFilter = THREE.NearestFilter;
    
    return texture;
  };
    
  this.initScrollingMaterial = function() {
    var texture = this.getTexture('scrollingMap.png');
    
    this.scrollingUniforms = {
      rotationField: { type: "t", value: this.scroller.getCurrentPositionTexture() },
      map: { type: "t", value: texture },
      rowCount: { type: "f", value: this.boxGrid.rowCount },
      columnCount: { type: "f", value: this.boxGrid.columnCount },
      boxLength: { type: "f", value: this.boxGrid.boxLengthInPixels },
      scroll_origin: { type: 'v2', value: new THREE.Vector2(0.5, 0.) }
    };
    
    return new THREE.RawShaderMaterial({
      uniforms: this.scrollingUniforms,
      vertexShader: ShaderLoader.get('scrolling_cube_vertex'),
      fragmentShader: ShaderLoader.get('scrolling_cube_fragment')
    });
  };
  
  this.initWaveMaterial = function() {    
    var texture = this.getTexture('waveMap.png');
    
    this.waveUniforms = {
      rotationField: { type: "t", value: this.waveSim.getCurrentPositionTexture() },
      map: { type: "t", value: texture },
      min_angle: { type: 'f', value: 0.08 },
      min_speed: { type: 'f', value: 0.1 },
      rowCount: { type: "f", value: this.boxGrid.rowCount },
      columnCount: { type: "f", value: this.boxGrid.columnCount },
      boxLength: { type: "f", value: this.boxGrid.boxLengthInPixels },
      scroll_origin: { type: 'v2', value: new THREE.Vector2(0.5, 0.) }
    };
    
    return new THREE.RawShaderMaterial({
      uniforms: this.waveUniforms,
      vertexShader: ShaderLoader.get('cube_vertex'),
      fragmentShader: ShaderLoader.get('cube_fragment')
    });
  };
  
  // INITIALIZATION AND MAIN RENDER LOOP
  this.init = function() {
    this.width  = window.innerWidth;
    this.height = window.innerHeight;
    
    var waveSimShaderHash = {
      simulation: {
        vertex: ShaderLoader.get('simulation_vertex'),
        fragment: ShaderLoader.get('simulation_fragment')
      },
      passThrough: {
        vertex: ShaderLoader.get('passthrough_vertex'),
        fragment: ShaderLoader.get('passthrough_fragment')
      }
    };
    
    var scrollingShaderHash = {
      scrolling: {
        vertex:   ShaderLoader.get('scrolling_vertex'),
        fragment: ShaderLoader.get('scrolling_fragment')
      },
      passThrough: {
        vertex: ShaderLoader.get('passthrough_vertex'),
        fragment: ShaderLoader.get('passthrough_fragment')
      }
    };
    
    this.container = document.getElementById( 'webgl-cubes-container' );
    
    this.boxGrid = new InstancedBoxGridGeometry(this.width, this.height);
    
    this.renderer.setClearColor( this.htmlScenes[0].end_clear_color );
    // this.renderer.setPixelRatio( window.devicePixelRatio );
    this.renderer.setSize( this.width, this.height );
    
    this.waveSim = new Simulation(this.renderer, 2 * this.boxGrid.columnCount, 2 * this.boxGrid.rowCount, waveSimShaderHash);
    this.waveSim.initSceneAndMeshes();
    
    this.scroller = new Scroller(this.renderer, this.boxGrid.columnCount, this.boxGrid.rowCount, scrollingShaderHash);
    this.scroller.initSceneAndMeshes();
    
    this.camera = new THREE.OrthographicCamera(
      0.99 * -.5 * this.width,
      0.99 *  .5 * this.width,
      0.99 *  .5 * this.height,
      0.99 * -.5 * this.height,
      1,
      this.boxGrid.boxLengthInPixels * (this.boxGrid.columnCount + this.boxGrid.rowCount + 2) );
    
    this.camera.position.z = this.boxGrid.boxLengthInPixels * this.boxGrid.rowCount;
    
    this.scene = new THREE.Scene();

    var geometry = this.boxGrid.geometry;
    // materials
    this.waveMaterial = this.initWaveMaterial();
    this.scrollingMaterial = this.initScrollingMaterial();

    this.mesh = new THREE.Mesh( geometry, this.waveMaterial );
    this.scene.add( this.mesh );

    // this.addDebugPlane(this.scene)
    
    this.container.appendChild( this.renderer.domElement );
    
    this.addEventListeners();
    // this.setUpGui();
    this.animate();
  };
  
  this.stopAnimating = function() {
    if (this.animationID != undefined) {
      cancelAnimationFrame( this.animationID );
      this.animationID = undefined;
    }
  }
  
  this.animate = function() {
    this.animationID = requestAnimationFrame( this.animate.bind(this) );

    if (this.isScrolling) {
      this.scroller.update();
      this.scroller.increaseScrollPosition();
    }
    this.waveSim.ticktock();
    this.waveSim.setSimUniform('using_mouse', 0);
    
    if (this.scroller.isScrollComplete()) this.disableScrolling();
    
    this.renderer.render( this.scene, this.camera );
  };
};
