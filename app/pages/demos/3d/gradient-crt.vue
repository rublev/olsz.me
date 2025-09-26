<script setup>
/*
 * CRT MONITOR GRADIENT DEMO
 *
 * This page recreates authentic 80's CRT monitor aesthetics with:
 * 1. Phosphor glow and color bleeding effects
 * 2. Subtle scanline simulation
 * 3. Screen curvature and bezel effects
 * 4. Gamma correction for authentic CRT color response
 * 5. Chromatic aberration and monitor flicker
 * 6. Enhanced pixelate post-processing for retro digital feel
 */

// Three.js for 3D graphics
import * as THREE from 'three'

// Vue imports
import { onMounted, ref } from 'vue'

import crtFragmentShader from '~/assets/shaders/crt-fragment.glsl?raw' // CRT monitor effects
import pixelateFragmentShader from '~/assets/shaders/pixelate-fragment.glsl?raw' // Pixelation effect
import pixelateVertexShader from '~/assets/shaders/pixelate-vertex.glsl?raw' // Post-processing vertex
// Import our custom shaders as raw strings
import sNoiseShader from '~/assets/shaders/snoise.glsl?raw' // Simplex noise function
import vertexShader from '~/assets/shaders/vertex.glsl?raw' // Creates wavy mesh distortion

// Vue reactive reference to the canvas container div
const canvasContainer = ref(null)

// Helper function: Generate random integer between min and max (inclusive)
function randomInteger(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min
}

// Helper function: Convert RGB values to Three.js Vector3 format
function rgb(r, g, b) {
  return new THREE.Vector3(r, g, b)
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
  const postCamera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1)

  /*
   * ANIMATION VARIABLES
   */

  let vCheck = false // Direction flag for the oscillating x variable
  camera.position.z = 5 // Move camera back so we can see the mesh

  // Random position offset for making the noise animation more organic
  const randomisePosition = new THREE.Vector2(1, 2)

  /*
   * CRT MONITOR COLOR FUNCTIONS
   * These create colors typical of 80's CRT monitors with phosphor limitations
   * Emphasizing the classic amber, green, and early color monitor palettes
   */

  // Red channel: Warm amber and orange phosphor tones
  const R = function (x, y, t) {
    return Math.floor(180 + 75 * Math.cos((x * x - y * y) / 400 + t * 0.8))
  }

  // Green channel: Classic green monitor phosphor
  const G = function (x, y, t) {
    return Math.floor(
      160
      + 80
      * Math.sin((x * x * Math.cos(t / 5) + y * y * Math.sin(t / 4)) / 350),
    )
  }

  // Blue channel: Deep blue phosphor with subtle variation
  const B = function (x, y, t) {
    return Math.floor(
      140
      + 60
      * Math.sin(
        4 * Math.sin(t / 10)
        + ((x - 100) * (x - 100) + (y - 100) * (y - 100)) / 900,
      ),
    )
  }

  /*
   * CRT MESH CREATION
   */

  // Create mesh with appropriate resolution for CRT phosphor simulation
  const geometry = new THREE.PlaneGeometry(
    window.innerWidth / 2,
    450,
    110,
    110,
  )

  // Create material with CRT shader
  const material = new THREE.ShaderMaterial({
    uniforms: {
      // CRT-style color palette - warm phosphor tones
      u_bg: { type: 'v3', value: rgb(20, 25, 30) }, // Dark screen background
      u_bgMain: { type: 'v3', value: rgb(15, 20, 25) }, // Even darker bezel area
      u_color1: { type: 'v3', value: rgb(255, 180, 60) }, // Warm amber phosphor
      u_color2: { type: 'v3', value: rgb(80, 220, 100) }, // Classic green phosphor
      u_time: { type: 'f', value: 30 }, // Animation time counter
      u_randomisePosition: { type: 'v2', value: randomisePosition }, // Organic movement offset
    },
    // Combine noise shader with our CRT fragment shader
    fragmentShader: sNoiseShader + crtFragmentShader,
    // Use same vertex shader for mesh distortion
    vertexShader: sNoiseShader + vertexShader,
  })

  /*
   * MESH POSITIONING AND SCALING
   */

  // Create the mesh (geometry + material)
  const mesh = new THREE.Mesh(geometry, material)

  // Position for optimal CRT monitor viewing
  mesh.position.set(-150, 220, -260) // Positioned like a desktop monitor
  mesh.scale.multiplyScalar(3.8) // Appropriate size for monitor simulation

  // CRT monitor orientation
  mesh.rotationX = -0.9 // Slightly tilted like an old desktop monitor
  mesh.rotationY = 0.0
  mesh.rotationZ = 0.02 // Very subtle rotation

  // Add the mesh to our 3D scene
  scene.add(mesh)

  /*
   * PIXELATE POST-PROCESSING SETUP
   * Enhanced for CRT monitor pixel grid simulation
   */

  // Create material for the pixelate effect with moderate intensity for CRT
  // feel
  const pixelateMaterial = new THREE.ShaderMaterial({
    uniforms: {
      tDiffuse: { value: null }, // Will hold the original rendered image
      u_resolution: {
        value: new THREE.Vector2(window.innerWidth, window.innerHeight),
      }, // Screen size
      intensity: { value: 0.25 }, // Moderate pixelation for CRT pixel grid
    },
    vertexShader: pixelateVertexShader,
    fragmentShader: pixelateFragmentShader,
  })

  // Create fullscreen quad for post-processing
  const postGeometry = new THREE.PlaneGeometry(2, 2)
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

  // Color animation variables for CRT phosphor cycling
  let x = randomInteger(0, 32)
  const y = randomInteger(0, 32)

  /*
   * MAIN ANIMATION LOOP
   * Enhanced for CRT monitor aesthetics
   */
  const animate = function () {
    requestAnimationFrame(animate) // Schedule next frame

    /*
     * TWO-PASS RENDERING
     * Pass 1: Render CRT gradient to texture
     * Pass 2: Apply pixelate effect and render to screen
     */

    // PASS 1: Render the CRT scene to our render target texture
    renderer.setRenderTarget(renderTarget)
    renderer.render(scene, camera)

    // PASS 2: Apply pixelate effect to the captured texture
    pixelateMaterial.uniforms.tDiffuse.value = renderTarget.texture

    // Render the pixelated result to the actual screen
    renderer.setRenderTarget(null)
    renderer.render(postScene, postCamera)

    /*
     * UPDATE SHADER UNIFORMS
     * Send new values to our CRT shaders each frame
     */

    // Update organic movement with CRT-appropriate timing
    mesh.material.uniforms.u_randomisePosition.value = new THREE.Vector2(
      j * 0.7,
      j * 0.7,
    )

    // Update phosphor colors using our CRT color functions
    mesh.material.uniforms.u_color1.value = new THREE.Vector3(
      R(x, y, t / 2.5), // Phosphor refresh timing
      G(x, y, t / 2.5),
      B(x, y, t / 2.5),
    )

    // Update time for shader animations
    mesh.material.uniforms.u_time.value = t

    /*
     * CRT PHOSPHOR CYCLING
     * Simulate changing phosphor patterns like old monitors
     */
    if (t % 0.12 === 0) {
      // CRT refresh-like timing
      if (vCheck === false) {
        x -= 1
        if (x <= 0) {
          vCheck = true
        }
      }
      else {
        x += 1
        if (x >= 32) {
          vCheck = false
        }
      }
    }

    /*
     * INCREMENT TIME COUNTERS
     * CRT-appropriate timing for authentic feel
     */
    j = j + 0.009 // Smooth phosphor movement
    t = t + 0.045 // Steady refresh rate
  }

  // Start the animation loop
  animate()
})
</script>

<template>
  <!--
    CRT MONITOR CANVAS CONTAINER
    This div holds our Three.js canvas for the CRT monitor simulation
  -->
  <div
    ref="canvasContainer"
    class="absolute top-0 left-0 h-full w-full bg-black"
  />
</template>
