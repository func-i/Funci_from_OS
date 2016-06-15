"use strict";

function Simulation(renderer, width, height, shaderHash) {
  GenericSimulation.call(this, renderer, width, height, shaderHash);
  
  this.getSimulationMaterial = function() {
    return new THREE.RawShaderMaterial({
      uniforms: {
        position_texture: { type: 't', value: this.getCurrentPositionTexture() },
        mouse: { type: "v2", value: new THREE.Vector2(0,0) },
        dx: { type: 'f', value: 1/this.width },
        dy: { type: 'f', value: 1/this.height },
        width: { type: 'f', value: this.width },
        height: { type: 'f', value: this.height },
        wave_speed: { type: 'f', value: 0.3 / Math.max(this.width, this.height) },
        damping_strength: { type: 'f', value: 0.02 },
        mouse_magnitude: { type: "f", value: 0.0 },
        draw_radius: { type: "f", value: 2 / this.width },
        scrollPosition: { type: "f", value: 0. }        
      },
      vertexShader: this.shaderHash.simulation.vertex,
      fragmentShader: this.shaderHash.simulation.fragment
    });
  };
  
  this.changeMousePosition = function(mouse) {
    this.setSimUniform('mouse', mouse);
    this.setSimUniform('mouse_magnitude', 1);
  };
};

Simulation.prototype = Object.create(GenericSimulation.prototype);
Simulation.prototype.constructor = Simulation;
