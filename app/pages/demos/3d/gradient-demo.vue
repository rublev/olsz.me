<script setup lang="ts">
/*
 * GRADIENT DEMO WITH PIXELATE EFFECT
 *
 * This page creates an animated gradient mesh with a retro pixelate
 * post-processing effect. It combines: 1. A wavy,
 * noise-distorted gradient mesh (like Stripe's website backgrounds) 2.
 * A pixelate shader that makes it look retro/8-bit 3.
 * Dynamic color animation that cycles through different hues
 */

// Three.js for 3D graphics
import * as THREE from 'three'

// Vue imports
import { onMounted, ref } from 'vue'

import fragmentShader from '~/assets/shaders/fragment.glsl?raw' // Creates gradient colors
import pixelateFragmentShader from '~/assets/shaders/pixelate-fragment.glsl?raw' // Pixelation effect
import pixelateVertexShader from '~/assets/shaders/pixelate-vertex.glsl?raw' // Post-processing vertex
// Import our custom shaders as raw strings
import sNoiseShader from '~/assets/shaders/snoise.glsl?raw' // Simplex noise function
import vertexShader from '~/assets/shaders/vertex.glsl?raw' // Creates wavy mesh distortion

// Vue reactive reference to the canvas container div
const canvasContainer = ref<HTMLDivElement | null>(null)

// Helper function: Generate random integer between min and max (inclusive)
function randomInteger(min: number, max: number) {
  return Math.floor(Math.random() * (max - min + 1)) + min
}

// Helper function: Convert RGB values to Three.js Vector3 format
// Three.js expects colors as Vector3 objects for shader uniforms
function rgb(r: number, g: number, b: number) {
  return new THREE.Vector3(r, g, b)
}

onMounted(() => {
  if (!canvasContainer.value)
    return

  /*
   * THREE.JS SETUP
   * Initialize the 3D graphics system
   */

  // Create the WebGL renderer (uses GPU for fast graphics)
  const renderer = new THREE.WebGLRenderer()
  renderer.setSize(window.innerWidth, window.innerHeight) // Make it fill the screen
  canvasContainer.value.appendChild(renderer.domElement) // Add canvas to our Vue template

  // Create the main 3D scene and camera
  const scene = new THREE.Scene() // Container for all 3D objects
  const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000,
  )

  /*
   * POST-PROCESSING SETUP Create a second rendering pipeline for applying
   * effects after the main render
   */

  // Render target: like a canvas where we draw the original scene first
  const renderTarget = new THREE.WebGLRenderTarget(
    window.innerWidth,
    window.innerHeight,
  )

  // Post-processing scene: separate scene just for applying effects
  const postScene = new THREE.Scene()

  // Orthographic camera: renders a flat rectangle covering the entire screen
  // Perfect for post-processing effects that need to cover every pixel
  const postCamera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1)

  /*
   * ANIMATION VARIABLES
   */

  let vCheck = false // Direction flag for the oscillating x variable
  camera.position.z = 5 // Move camera back so we can see the mesh

  // Random position offset for making the noise animation more organic
  const randomisePosition = new THREE.Vector2(1, 2)

  /*
   * DYNAMIC COLOR FUNCTIONS These create organic,
   * shifting colors based on position and time Each function (R, G,
   * B) uses different mathematical patterns to create interesting color
   * variations
   */

  // Red channel: Creates flowing red patterns using cosine waves
  // Base of 192 + variation of 64 = colors range from 128-256 (bright)
  const R = function (x: number, y: number, t: number) {
    return Math.floor(192 + 64 * Math.cos((x * x - y * y) / 300 + t))
  }

  // Green channel: More complex pattern using sine with time-based frequency
  // modulation The cos(t/4) and sin(t/3) make the pattern evolve slowly over
  // time
  const G = function (x: number, y: number, t: number) {
    return Math.floor(
      192
      + 64
      * Math.sin((x * x * Math.cos(t / 4) + y * y * Math.sin(t / 3)) / 300),
    )
  }

  // Blue channel: Radial patterns centered at (100,
  // 100) with complex time modulation The sin(t/9) creates very slow,
  // deep oscillations in the pattern
  const B = function (x: number, y: number, t: number) {
    return Math.floor(
      192
      + 64
      * Math.sin(
        5 * Math.sin(t / 9)
        + ((x - 100) * (x - 100) + (y - 100) * (y - 100)) / 1100,
      ),
    )
  }

  /*
   * GRADIENT MESH CREATION
   */

  // Create a flat rectangle divided into a 100x100 grid of vertices
  // This gives us lots of points to distort with our vertex shader
  const geometry = new THREE.PlaneGeometry(
    window.innerWidth / 2,
    400,
    100,
    100,
  )

  // Create material with our custom shaders
  const material = new THREE.ShaderMaterial({
    uniforms: {
      // ORIGINAL
      u_bg: { value: rgb(255, 255, 0) }, // Background color (purple)
      u_bgMain: { value: rgb(255, 0, 0) }, // Main background (purple)
      u_color1: { value: rgb(0, 255, 0) }, // First gradient color (purple)
      u_color2: { value: rgb(0, 0, 255) }, // Second gradient color (darker purple)
      u_time: { value: 30 }, // Animation time counter
      u_randomisePosition: { value: randomisePosition }, // Organic movement offset
      // NORMAL
      // u_bg: { value: rgb(0, 0, 0) }, // Background color (purple)
      // u_bgMain: { value: rgb(0, 0, 0) }, // Main background (purple)
      // u_color1: { value: rgb(0, 0, 0) }, // First gradient color (purple)
      // u_color2: { value: rgb(0, 0, 0) }, // Second gradient color (darker purple)
      // u_time: { value: 30 }, // Animation time counter
      // u_randomisePosition: { value: randomisePosition } // Organic movement offset
    },
    // Combine noise shader with our fragment shader
    fragmentShader: sNoiseShader + fragmentShader,
    // Combine noise shader with our vertex shader
    vertexShader: sNoiseShader + vertexShader,
  })

  /*
   * MESH POSITIONING AND SCALING
   */

  // Create the mesh (geometry + material)
  const mesh = new THREE.Mesh(geometry, material)

  // Position the mesh in 3D space
  mesh.position.set(-200, 270, -280) // Move it left, up, and back

  // Scale it up to fill more of the screen
  mesh.scale.multiplyScalar(4) // Make it 4x bigger

  // Rotate it for a more dynamic angle
  mesh.rotation.x = -1.0 // Tilt it forward
  mesh.rotation.y = 0.0 // No left/right rotation
  mesh.rotation.z = 0.1 // Slight roll for visual interest

  // Add the mesh to our 3D scene
  scene.add(mesh)

  /*
   * PIXELATE POST-PROCESSING SETUP
   */

  // Create material for the pixelate effect
  const pixelateMaterial = new THREE.ShaderMaterial({
    uniforms: {
      tDiffuse: { value: null }, // Will hold the original rendered image
      u_resolution: {
        value: new THREE.Vector2(window.innerWidth, window.innerHeight),
      }, // Screen size
      intensity: { value: 2 }, // Pixelation strength (0.0 = none, 1.0 = very blocky)
    },
    vertexShader: pixelateVertexShader, // Simple pass-through vertex shader
    fragmentShader: pixelateFragmentShader, // The pixelation magic happens here
  })

  // Create a fullscreen rectangle for post-processing
  // This rectangle covers the entire screen and displays our pixelated result
  const postGeometry = new THREE.PlaneGeometry(2, 2) // 2x2 fills the entire screen (-1 to 1)
  const postMesh = new THREE.Mesh(postGeometry, pixelateMaterial)
  postScene.add(postMesh)

  /*
   * ANIMATION SETUP
   */

  // Render the scene once to initialize
  renderer.render(scene, camera)

  // Animation time variables
  let t = 0 // Main time counter
  let j = 0 // Secondary time counter for organic movement

  // Color animation variables
  let x = randomInteger(0, 32) // X coordinate for color functions
  const y = randomInteger(0, 32) // Y coordinate for color functions (not currently animated)

  /*
   * MAIN ANIMATION LOOP
   * This runs 60 times per second to create smooth animation
   */
  const animate = function () {
    requestAnimationFrame(animate) // Schedule next frame

    /*
     * TWO-PASS RENDERING
     * Pass 1: Render gradient to texture
     * Pass 2: Apply pixelate effect and render to screen
     */

    // PASS 1: Render the original gradient scene to our render target texture
    renderer.setRenderTarget(renderTarget) // Draw to texture instead of screen
    renderer.render(scene, camera) // Render the gradient mesh

    // PASS 2: Apply pixelate effect to the captured texture
    pixelateMaterial.uniforms.tDiffuse!.value = renderTarget.texture // Pass texture to pixelate shader

    // Render the pixelated result to the actual screen
    renderer.setRenderTarget(null) // Draw to screen now
    renderer.render(postScene, postCamera) // Render fullscreen quad with pixelate effect

    /*
     * UPDATE SHADER UNIFORMS
     * Send new values to our shaders each frame
     */

    // Update organic movement offset for vertex distortion
    mesh.material.uniforms.u_randomisePosition!.value = new THREE.Vector2(j, j)

    // Update gradient colors using our dynamic color functions
    mesh.material.uniforms.u_color1!.value = new THREE.Vector3(
      R(x, y, t / 2), // Red component
      G(x, y, t / 2), // Green component
      B(x, y, t / 2), // Blue component
    )

    // Update time for shader animations
    mesh.material.uniforms.u_time!.value = t

    /*
     * COLOR ANIMATION LOGIC
     * Make the x variable oscillate back and forth (0 to 32 and back)
     * This creates slow color transitions in our gradient
     */
    if (t % 0.1 === 0) {
      // Only update every 10th of a unit (for slower color changes)
      if (vCheck === false) {
        x -= 1 // Decrease x
        if (x <= 0) {
          vCheck = true // Switch direction when we hit 0
        }
      }
      else {
        x += 1 // Increase x
        if (x >= 32) {
          vCheck = false // Switch direction when we hit 32
        }
      }
    }

    /*
     * INCREMENT TIME COUNTERS
     */
    j = j + 0.01 // Slow organic movement increment
    t = t + 0.05 // Main time increment
  }

  // Start the animation loop
  animate()

  // document.documentElement.style.setProperty('--safe-user-color', '#74ed86')
  document.documentElement.style.setProperty('--safe-user-color', '#0000ff')
})
</script>

<template>
  <div>
    <!--
    CANVAS CONTAINER
    This div holds our Three.js canvas and covers the entire viewport
    The canvas gets dynamically added to this div in the onMounted function
  -->
    <!-- <div
      style="
        position: fixed;
        top: 50%;
        left: 50%;
        width: 100%;
        height: 100%;
        transform: translate(-50%, -50%);
        background: rgba(255, 255, 255, 0.8);
        z-index: 1000;
        border-radius: 12px;
        box-shadow: 0 2px 16px rgba(0, 0, 0, 0.12);
        pointer-events: none;
        background-color: var(--safe-user-color); /* Uses the dynamically calculated color */
        mix-blend-mode: color-burn;
        /* background: red; */
        font-size: 80px;
        text-align: center;
        padding-top: 350px;
      "
    ></div> -->
    <div
      style="
        mix-blend-mode: color-burn;
        /* color: green; */
        mix-blend-mode: difference;
        /* filter: grayscale(); */
        /* mix-blend-mode: luminosity; */
        /* filter: invert(1) grayscale(1) contrast(200%); */
        position: absolute;
        top: 100px;
        left: 50px;
        color: #00ff00;
        z-index: 1;
        /* z-index: 500; */
        font-size: 200px;
      "
    >
      awdawdawd
    </div>
    <div
      ref="canvasContainer"
      class="h-full w-full p-10"
      style="
        position: fixed;
        width: 100%;
        height: 100%;
        transform: translate(-50%, -50%);
        /* background: red; */
        /* background: rgba(255, 255, 255, 0.8); */
        z-index: 1000;
        border-radius: 12px;
        box-shadow: 0 2px 16px rgba(0, 0, 0, 0.12);
        pointer-events: none;
        /* background-color: var(--safe-user-color); */ /* Uses the dynamically calculated color */
        /* mix-blend-mode: luminosity; */
        filter: invert(1) contrast(200%);
        mix-blend-mode: color-burn;
        mix-blend-mode: hard-light;
        /* background: red; */
        /* font-size: 80px; */
        /* text-align: center; */
        /* padding-top: 350px; */
      "
    />
  </div>
</template>

<style lang="css">
/* =====================================
  CSS VARIABLES AND GLOBAL SETUP
  ===================================== */

:root {
  /* CSS custom property that will hold the calculated safe color */
  /* This gets dynamically updated by JavaScript with the exact color value */
  --safe-user-color: #74ed86; /* Default fallback, will be overridden */
}

.selectable {
  position: absolute; /* Each item has exact pixel positioning */
  cursor: pointer; /* Show pointer cursor on hover */
  transition: filter 0.3s ease; /* Smooth transition when filter effects are applied */
  border-radius: 8px; /* Rounded corners like Kinopio cards */
  border: 1px solid red;
}

/* When an item is selected, it gets a colored background */
.selectable .selected {
  background-color: var(
    --safe-user-color
  ); /* Uses the dynamically calculated color */
  background-color: yellow;
  mix-blend-mode: color-burn;
}
.selected {
  background-color: var(
    --safe-user-color
  ); /* Uses the dynamically calculated color */
  background-color: yellow;
  mix-blend-mode: color-burn;
}
</style>
