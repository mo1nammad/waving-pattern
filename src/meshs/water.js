import * as THREE from "three";

import { gui } from "../utils/gui.js";
import waterVertexShader from "../shaders/water/vertex.glsl";
import waterFragmentShader from "../shaders/water/fragment.glsl";

const debugObject = {
  depthColor: "#0510a5",
  surfaceColor: "#86e7fc",
};

const planeGeometry = new THREE.PlaneGeometry(21, 12, 1024, 1024);

const material = new THREE.ShaderMaterial({
  vertexShader: waterVertexShader,
  fragmentShader: waterFragmentShader,
  transparent: true,
  side: THREE.DoubleSide,
  //   wireframe: true,
  // uniforms: { // on 1 * 1 512 segment
  //   time: { value: 0 },

  //   uBigWavesElevation: { value: 0.13 },
  //   uBigWavesFrequency: { value: new THREE.Vector2(4, 1.5) },

  //   uDepthColor: { value: new THREE.Color(debugObject.depthColor) },
  //   uSurfaceColor: { value: new THREE.Color(debugObject.surfaceColor) },
  //   uFragElevationOffset: { value: 0.0598 },
  //   uFragElevationMulti: { value: 6.2201 },

  //   uSmWavesElevation: { value: 0.05 },
  //   uSmWavesFrequency: { value: 6.8 },
  //   uSmWavesSpeed: { value: 0.69 },
  // },
  uniforms: {
    // on 12 * 12 geometry 1024 segment
    time: { value: 0 },

    uBigWavesElevation: { value: 0.24 },
    uBigWavesFrequency: { value: new THREE.Vector2(0.4, 0.2) },

    uDepthColor: { value: new THREE.Color(debugObject.depthColor) },
    uSurfaceColor: { value: new THREE.Color(debugObject.surfaceColor) },
    uFragElevationOffset: { value: 0.098 },
    uFragElevationMulti: { value: 4.75 },

    uSmWavesElevation: { value: 0.27 },
    uSmWavesFrequency: { value: 0.6 },
    uSmWavesSpeed: { value: 0.82 },
  },
});

gui
  .add(material.uniforms.uBigWavesElevation, "value", 0, 1, 0.01)
  .name("uBigWavesElevation");

gui
  .add(material.uniforms.uBigWavesFrequency.value, "x", 0, 10, 0.01)
  .name("uBigWavesFrequency X");

gui
  .add(material.uniforms.uBigWavesFrequency.value, "y", 0, 10, 0.01)
  .name("uBigWavesFrequency Z");

// color
gui.addColor(debugObject, "depthColor").onFinishChange((value) => {
  material.uniforms.uDepthColor = { value: new THREE.Color(value) };
});

gui.addColor(debugObject, "surfaceColor").onFinishChange((value) => {
  material.uniforms.uSurfaceColor = { value: new THREE.Color(value) };
});

gui
  .add(material.uniforms.uFragElevationOffset, "value", 0, 5, 0.0001)
  .name("uFragElevationOffset");

gui
  .add(material.uniforms.uFragElevationMulti, "value", 0, 8, 0.0001)
  .name("uFragElevationMulti");

gui
  .add(material.uniforms.uSmWavesElevation, "value", 0, 1, 0.01)
  .name("uSmWavesElevation");

gui
  .add(material.uniforms.uSmWavesFrequency, "value", 0, 30, 0.1)
  .name("uSmWavesFrequency");

gui
  .add(material.uniforms.uSmWavesSpeed, "value", 0, 4, 0.01)
  .name("uSmWavesSpeed");

export const planeMesh = new THREE.Mesh(planeGeometry, material);
planeMesh.rotation.x = -Math.PI * 0.5;
