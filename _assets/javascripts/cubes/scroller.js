"use strict";

function Scroller(renderer, width, height, shaderHash) {
  this.SCROLL_THRESHOLD = 1.6
  this.isScrolling = false;
  this.scrollDuration = 1.0;
  
  GenericSimulation.call(this, renderer, width, height, shaderHash);  
  
  this.getSimulationMaterial = function() {
    return new THREE.RawShaderMaterial({
      uniforms: this.simUniforms,
      vertexShader: this.shaderHash.scrolling.vertex,
      fragmentShader: this.shaderHash.scrolling.fragment
    });
  };
    
  this.setupUniforms = function() {
    this.simUniforms = {
      position_texture: { type: 't', value: this.getCurrentPositionTexture() },
      rotation_rate: {type: 'f', value: 0.04 },
      scroll_position: { type: 'f', value: 0.0 },
      scroll_origin: { type: 'v2', value: new THREE.Vector2(0.5, 0.) },
      final_scroll_value: { type: 'f', value: 0.5 }
    };
  };
  
  this.setFinalScrollValue = function(scrollValue) {
    this.setSimUniform('final_scroll_value', scrollValue)
  };
  
  this.increaseScrollPosition = function() {
    var scrollDelta = 1 / this.scrollDuration / 60;
    var scrollPosition = this.getSimUniform('scroll_position') + scrollDelta;
    this.setSimUniform('scroll_position', scrollPosition);
  };
  
  this.addGuiFolder = function(gui) {
    var folder = gui.addFolder("Scrolling Effect")
    folder.add(this.simUniforms.rotation_rate, 'value', 0.001, 0.1).name("Rotation Rate");
    folder.add(this, 'scrollDuration', 0.01, 3).name("Transition Duration (s)");
  };
  
  this.isScrollComplete = function() {
    return this.getSimUniform('scroll_position') > this.SCROLL_THRESHOLD
  };
};

Scroller.prototype = Object.create(GenericSimulation.prototype);
Scroller.prototype.constructor = Scroller;
