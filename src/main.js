import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";

import { gui } from "./utils/gui.js";

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
camera.position.set(0, 5, 0);

// renderer
const renderer = new THREE.WebGLRenderer({});
renderer.shadowMap.enabled;
renderer.setSize(Sizes.width, Sizes.height);
document.body.appendChild(renderer.domElement);

// controls
const controls = new OrbitControls(camera, renderer.domElement);
controls.update();
controls.enableDamping = true;

import { planeMesh } from "./meshs/water.js";
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
  planeMesh.material.uniforms.time.value = elapsedTime;

  controls.update();
  renderer.render(scene, camera);
  requestAnimationFrame(animate);
}

animate();
