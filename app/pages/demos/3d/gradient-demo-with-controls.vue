<script setup>
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
import { onMounted, reactive, ref } from 'vue'

import fragmentShader from '~/assets/shaders/fragment.glsl?raw' // Creates gradient colors
import pixelateFragmentShader from '~/assets/shaders/pixelate-fragment.glsl?raw' // Pixelation effect
import pixelateVertexShader from '~/assets/shaders/pixelate-vertex.glsl?raw' // Post-processing vertex
// Import our custom shaders as raw strings
import sNoiseShader from '~/assets/shaders/snoise.glsl?raw' // Simplex noise function
import vertexShader from '~/assets/shaders/vertex.glsl?raw' // Creates wavy mesh distortion

// Vue reactive reference to the canvas container div
const canvasContainer = ref(null)

// Reactive state for gradient controls
const controls = reactive({
  enabled: true,
  mode: 'mathematical', // 'mathematical' or 'manual'
  pixelateIntensity: 2,
  animationSpeed: 1,
  colors: {
    bg: '#ffff00',
    bgMain: '#ff0000',
    color1: '#00ff00',
    color2: '#0000ff',
  },
  presets: [
    {
      name: 'Electric',
      bg: '#ff00ff',
      bgMain: '#ff0080',
      color1: '#00ffff',
      color2: '#8000ff',
    },
    {
      name: 'Sunset',
      bg: '#ff6b00',
      bgMain: '#ff3d00',
      color1: '#ffab00',
      color2: '#ff1744',
    },
    {
      name: 'Ocean',
      bg: '#00bcd4',
      bgMain: '#0097a7',
      color1: '#26c6da',
      color2: '#006064',
    },
    {
      name: 'Forest',
      bg: '#4caf50',
      bgMain: '#388e3c',
      color1: '#66bb6a',
      color2: '#1b5e20',
    },
  ],
})

// Helper function: Generate random integer between min and max (inclusive)
function randomInteger(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min
}

// Helper function: Convert RGB values to Three.js Vector3 format
// Three.js expects colors as Vector3 objects for shader uniforms
function rgb(r, g, b) {
  return new THREE.Vector3(r, g, b)
}

// Helper function: Convert hex color to RGB Vector3
function hexToRgb(hex) {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  return result
    ? new THREE.Vector3(Number.parseInt(result[1], 16), Number.parseInt(result[2], 16), Number.parseInt(result[3], 16))
    : new THREE.Vector3(255, 255, 255)
}

// Load a color preset
function loadPreset(preset) {
  controls.colors.bg = preset.bg
  controls.colors.bgMain = preset.bgMain
  controls.colors.color1 = preset.color1
  controls.colors.color2 = preset.color2
}

onMounted(() => {
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
  const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)

  /*
   * POST-PROCESSING SETUP Create a second rendering pipeline for applying
   * effects after the main render
   */

  // Render target: like a canvas where we draw the original scene first
  const renderTarget = new THREE.WebGLRenderTarget(window.innerWidth, window.innerHeight)

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
  const R = function (x, y, t) {
    return Math.floor(192 + 64 * Math.cos((x * x - y * y) / 300 + t))
  }

  // Green channel: More complex pattern using sine with time-based frequency
  // modulation The cos(t/4) and sin(t/3) make the pattern evolve slowly over
  // time
  const G = function (x, y, t) {
    return Math.floor(192 + 64 * Math.sin((x * x * Math.cos(t / 4) + y * y * Math.sin(t / 3)) / 300))
  }

  // Blue channel: Radial patterns centered at (100,
  // 100) with complex time modulation The sin(t/9) creates very slow,
  // deep oscillations in the pattern
  const B = function (x, y, t) {
    return Math.floor(192 + 64 * Math.sin(5 * Math.sin(t / 9) + ((x - 100) * (x - 100) + (y - 100) * (y - 100)) / 1100))
  }

  /*
   * GRADIENT MESH CREATION
   */

  // Create a flat rectangle divided into a 100x100 grid of vertices
  // This gives us lots of points to distort with our vertex shader
  const geometry = new THREE.PlaneGeometry(window.innerWidth / 2, 400, 100, 100)

  // Create material with our custom shaders
  const material = new THREE.ShaderMaterial({
    uniforms: {
      // ORIGINAL
      u_bg: { type: 'v3', value: rgb(255, 255, 0) }, // Background color (purple)
      u_bgMain: { type: 'v3', value: rgb(255, 0, 0) }, // Main background (purple)
      u_color1: { type: 'v3', value: rgb(0, 255, 0) }, // First gradient color (purple)
      u_color2: { type: 'v3', value: rgb(0, 0, 255) }, // Second gradient color (darker purple)
      u_time: { type: 'f', value: 30 }, // Animation time counter
      u_randomisePosition: { type: 'v2', value: randomisePosition }, // Organic movement offset
      // NORMAL
      // u_bg: { type: 'v3', value: rgb(0, 0, 0) }, // Background color (purple)
      // u_bgMain: { type: 'v3', value: rgb(0, 0, 0) }, // Main background (purple)
      // u_color1: { type: 'v3', value: rgb(0, 0, 0) }, // First gradient color (purple)
      // u_color2: { type: 'v3', value: rgb(0, 0, 0) }, // Second gradient color (darker purple)
      // u_time: { type: 'f', value: 30 }, // Animation time counter
      // u_randomisePosition: { type: 'v2', value: randomisePosition } // Organic movement offset
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
  mesh.rotationX = -1.0 // Tilt it forward
  mesh.rotationY = 0.0 // No left/right rotation
  mesh.rotationZ = 0.1 // Slight roll for visual interest

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
     * CONDITIONAL RENDERING
     * If effect is disabled, render nothing; otherwise do two-pass rendering
     */

    if (controls.enabled) {
      /*
       * TWO-PASS RENDERING
       * Pass 1: Render gradient to texture
       * Pass 2: Apply pixelate effect and render to screen
       */

      // PASS 1: Render the original gradient scene to our render target texture
      renderer.setRenderTarget(renderTarget) // Draw to texture instead of screen
      renderer.render(scene, camera) // Render the gradient mesh

      // PASS 2: Apply pixelate effect to the captured texture
      pixelateMaterial.uniforms.tDiffuse.value = renderTarget.texture // Pass texture to pixelate shader

      // Render the pixelated result to the actual screen
      renderer.setRenderTarget(null) // Draw to screen now
      renderer.render(postScene, postCamera) // Render fullscreen quad with pixelate effect
    }
    else {
      // Clear the screen when disabled
      renderer.setRenderTarget(null)
      renderer.clear()
    }

    /*
     * UPDATE SHADER UNIFORMS
     * Send new values to our shaders each frame
     */

    // Update organic movement offset for vertex distortion
    mesh.material.uniforms.u_randomisePosition.value = new THREE.Vector2(j, j)

    // Update gradient colors based on selected mode
    if (controls.mode === 'mathematical') {
      // Use dynamic mathematical color functions for all colors
      mesh.material.uniforms.u_color1.value = new THREE.Vector3(
        R(x, y, t / 2), // Red component
        G(x, y, t / 2), // Green component
        B(x, y, t / 2), // Blue component
      )
      // Apply variations for other colors to create more complex patterns
      mesh.material.uniforms.u_color2.value = new THREE.Vector3(
        R(x + 16, y + 16, t / 2), // Offset for variation
        G(x + 16, y + 16, t / 2),
        B(x + 16, y + 16, t / 2),
      )
      mesh.material.uniforms.u_bg.value = new THREE.Vector3(
        R(x + 8, y + 8, t / 3), // Different time scale
        G(x + 8, y + 8, t / 3),
        B(x + 8, y + 8, t / 3),
      )
      mesh.material.uniforms.u_bgMain.value = new THREE.Vector3(
        R(x + 24, y + 24, t / 4), // Another variation
        G(x + 24, y + 24, t / 4),
        B(x + 24, y + 24, t / 4),
      )
    }
    else {
      // Use manual colors from color pickers
      mesh.material.uniforms.u_bg.value = hexToRgb(controls.colors.bg)
      mesh.material.uniforms.u_bgMain.value = hexToRgb(controls.colors.bgMain)
      mesh.material.uniforms.u_color1.value = hexToRgb(controls.colors.color1)
      mesh.material.uniforms.u_color2.value = hexToRgb(controls.colors.color2)
    }

    // Update time for shader animations (with speed control)
    mesh.material.uniforms.u_time.value = t

    // Update pixelate intensity
    pixelateMaterial.uniforms.intensity.value = controls.pixelateIntensity

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
    j = j + 0.01 * controls.animationSpeed // Slow organic movement increment
    t = t + 0.05 * controls.animationSpeed // Main time increment
  }

  // Start the animation loop
  animate()

  // document.documentElement.style.setProperty('--safe-user-color', '#74ed86')
  document.documentElement.style.setProperty('--safe-user-color', '#0000ff')
})
</script>

<template>
  <div class="relative h-screen w-full overflow-hidden">
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
    <!-- <div
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
    </div> -->
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
        /* z-index: 1000; */
        border-radius: 12px;
        box-shadow: 0 2px 16px rgba(0, 0, 0, 0.12);
        pointer-events: none;
        /* background-color: var(--safe-user-color); */ /* Uses the dynamically calculated color */
        /* mix-blend-mode: luminosity; */
        /* filter: invert(1) contrast(200%); */
        /* mix-blend-mode: color-burn; */
        /* mix-blend-mode: hard-light; */
        /* background: red; */
        /* font-size: 80px; */
        /* text-align: center; */
        /* padding-top: 350px; */
      "
    />

    <!-- Canvas Container -->
    <!-- <div
      ref="canvasContainer"
      class="absolute inset-0 h-full w-full"
      style="filter: invert(1) contrast(200%); mix-blend-mode: hard-light; pointer-events: none"
    ></div> -->

    <!-- Controls Panel -->
    <div
      class="
        pointer-events-auto absolute top-4 left-4 min-w-80 rounded-lg
        bg-black/80 p-4 text-white backdrop-blur-sm
      "
    >
      <h2 class="mb-4 text-lg font-bold">
        Gradient Controls
      </h2>

      <!-- Main Enable/Disable Toggle -->
      <div class="mb-4">
        <label class="flex items-center gap-2">
          <input
            v-model="controls.enabled"
            type="checkbox"
            class="h-4 w-4"
          >
          <span>Enable Effect</span>
        </label>
      </div>

      <!-- Mode Toggle -->
      <div class="mb-4">
        <label class="mb-2 block text-sm font-medium">Mode</label>
        <div class="flex gap-2">
          <button
            class="rounded px-3 py-1 text-sm transition-colors" :class="[
              controls.mode === 'mathematical'
                ? 'bg-blue-600 text-white'
                : `
                  bg-gray-600 text-gray-300
                  hover:bg-gray-500
                `,
            ]"
            @click="controls.mode = 'mathematical'"
          >
            Mathematical
          </button>
          <button
            class="rounded px-3 py-1 text-sm transition-colors" :class="[
              controls.mode === 'manual' ? 'bg-purple-600 text-white' : `
                bg-gray-600 text-gray-300
                hover:bg-gray-500
              `,
            ]"
            @click="controls.mode = 'manual'"
          >
            Manual
          </button>
        </div>
      </div>

      <!-- Manual Color Controls (only shown in manual mode) -->
      <div
        v-if="controls.mode === 'manual'"
        class="mb-4"
      >
        <h3 class="mb-3 text-sm font-medium">
          Colors
        </h3>

        <!-- Color Presets -->
        <div class="mb-3">
          <label class="mb-2 block text-xs font-medium">Presets</label>
          <div class="grid grid-cols-2 gap-2">
            <button
              v-for="preset in controls.presets"
              :key="preset.name"
              class="
                rounded bg-gray-700 px-2 py-1 text-xs transition-colors
                hover:bg-gray-600
              "
              @click="loadPreset(preset)"
            >
              {{ preset.name }}
            </button>
          </div>
        </div>

        <!-- Individual Color Pickers -->
        <div class="grid grid-cols-2 gap-3">
          <div>
            <label class="mb-1 block text-xs font-medium">Background</label>
            <input
              v-model="controls.colors.bg"
              type="color"
              class="h-8 w-full rounded border-0"
            >
          </div>
          <div>
            <label class="mb-1 block text-xs font-medium">BG Main</label>
            <input
              v-model="controls.colors.bgMain"
              type="color"
              class="h-8 w-full rounded border-0"
            >
          </div>
          <div>
            <label class="mb-1 block text-xs font-medium">Color 1</label>
            <input
              v-model="controls.colors.color1"
              type="color"
              class="h-8 w-full rounded border-0"
            >
          </div>
          <div>
            <label class="mb-1 block text-xs font-medium">Color 2</label>
            <input
              v-model="controls.colors.color2"
              type="color"
              class="h-8 w-full rounded border-0"
            >
          </div>
        </div>
      </div>

      <!-- Animation Speed Control -->
      <div class="mb-4">
        <label class="mb-2 block text-sm font-medium">
          Animation Speed: {{ controls.animationSpeed.toFixed(1) }}x
        </label>
        <input
          v-model.number="controls.animationSpeed"
          type="range"
          min="0"
          max="3"
          step="0.1"
          class="w-full"
        >
      </div>

      <!-- Pixelate Intensity Control -->
      <div class="mb-4">
        <label class="mb-2 block text-sm font-medium"> Pixelate Intensity: {{ controls.pixelateIntensity }} </label>
        <input
          v-model.number="controls.pixelateIntensity"
          type="range"
          min="0"
          max="10"
          step="0.5"
          class="w-full"
        >
      </div>

      <!-- Mode Description -->
      <div class="text-xs text-gray-400">
        <div v-if="controls.mode === 'mathematical'">
          🌈 Mathematical mode uses complex functions to create organic, rainbow-like gradients that change over time
        </div>
        <div v-else>
          🎨 Manual mode lets you pick specific colors and create custom gradient combinations
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="css">
/* Custom range slider styling for dark theme */
input[type='range'] {
  appearance: none;
  background: transparent;
  cursor: pointer;
}

input[type='range']::-webkit-slider-track {
  background: #374151;
  height: 4px;
  border-radius: 2px;
}

input[type='range']::-webkit-slider-thumb {
  appearance: none;
  height: 16px;
  width: 16px;
  border-radius: 50%;
  background: #60a5fa;
  cursor: pointer;
  border: none;
}

input[type='range']::-moz-range-track {
  background: #374151;
  height: 4px;
  border-radius: 2px;
  border: none;
}

input[type='range']::-moz-range-thumb {
  height: 16px;
  width: 16px;
  border-radius: 50%;
  background: #60a5fa;
  cursor: pointer;
  border: none;
}

/* Custom color input styling */
input[type='color'] {
  border: none;
  cursor: pointer;
}

input[type='color']::-webkit-color-swatch-wrapper {
  padding: 0;
  border-radius: 4px;
  overflow: hidden;
}

input[type='color']::-webkit-color-swatch {
  border: none;
  border-radius: 4px;
}
</style>
