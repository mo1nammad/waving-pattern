import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";

import testVertexShader from "./shaders/test/vertex.glsl";
import testFragmentShader from "./shaders/test/fragment.glsl";
import gptFragmentShader from "./shaders/gpt/fragment.glsl";
// scene
const scene = new THREE.Scene();

const Sizes = {
  width: window.innerWidth,
  height: window.innerHeight,
};

const camera = new THREE.PerspectiveCamera(
  75,
  Sizes.width / Sizes.height,
  0.05,
  100
);
camera.position.set(0, 1, 2);

// renderer
const renderer = new THREE.WebGLRenderer({});
renderer.shadowMap.enabled;
renderer.setSize(Sizes.width, Sizes.height);
document.body.appendChild(renderer.domElement);

// controls
const controls = new OrbitControls(camera, renderer.domElement);
controls.update();
controls.enableDamping = true;

const planeGeometry = new THREE.PlaneGeometry(1, 1, 32, 32);

const material = new THREE.ShaderMaterial({
  vertexShader: testVertexShader,
  fragmentShader: testFragmentShader,
  uniforms: {
    elapsedTime: { value: 0 },
  },
  side: THREE.DoubleSide,
});

const planeMesh = new THREE.Mesh(planeGeometry, material);

scene.add(planeMesh);
window.addEventListener("resize", () => {
  Sizes.width = window.innerWidth;
  Sizes.height = window.innerHeight;

  camera.aspect = Sizes.width / Sizes.height;
  camera.updateProjectionMatrix();

  renderer.setSize(Sizes.width, Sizes.height);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
});

const clock = new THREE.Clock();

function animate() {
  const elapsedTime = clock.getElapsedTime();
  material.uniforms.elapsedTime.value = elapsedTime;

  controls.update();
  renderer.render(scene, camera);
  requestAnimationFrame(animate);
}

animate();
