import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";

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
camera.position.set(0, 1, 3);

// renderer
const renderer = new THREE.WebGLRenderer();
renderer.setSize(Sizes.width, Sizes.height);
document.body.appendChild(renderer.domElement);

// controls
const controls = new OrbitControls(camera, renderer.domElement);
controls.update();
controls.enableDamping = true;

const ambientLight = new THREE.AmbientLight("#86cdff", 0.6);
scene.add(ambientLight);

const cube = new THREE.Mesh(
  new THREE.BoxGeometry(1, 1, 1),
  new THREE.MeshStandardMaterial()
);
scene.add(cube);

window.addEventListener("resize", () => {
  Sizes.width = window.innerWidth;
  Sizes.height = window.innerHeight;

  camera.aspect = Sizes.width / Sizes.height;
  camera.updateProjectionMatrix();

  renderer.setSize(Sizes.width, Sizes.height);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
});

function animate() {
  controls.update();
  renderer.render(scene, camera);
  requestAnimationFrame(animate);
}

animate();
