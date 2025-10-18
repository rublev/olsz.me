<script setup lang="ts">
/*
 * RISOGRAPH GRADIENT DEMO
 *
 * This page recreates authentic risograph printing aesthetics with:
 * 1. Radial gradients that mimic ink flow and absorption
 * 2. Color quantization for classic print registration effects
 * 3. Vibrant, saturated colors typical of risograph prints
 * 4. Organic movement and color separation
 * 5. Pixelate post-processing for retro print texture
 */

// Three.js for 3D graphics
import * as THREE from 'three'

// Vue imports
import { onMounted, ref } from 'vue'

import pixelateFragmentShader from '~/assets/shaders/pixelate-fragment.glsl?raw' // Pixelation effect
import pixelateVertexShader from '~/assets/shaders/pixelate-vertex.glsl?raw' // Post-processing vertex
import risographFragmentShader from '~/assets/shaders/risograph-fragment.glsl?raw' // Risograph print effects
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
   * RISOGRAPH COLOR FUNCTIONS
   * These create vibrant, saturated colors typical of risograph printing
   * Using more intense, acidic colors for that authentic print shop look
   */

  // Red channel: Vibrant magentas and hot pinks
  const R = function (x, y, t) {
    return Math.floor(220 + 35 * Math.cos((x * x - y * y) / 200 + t * 1.2))
  }

  // Green channel: Acid greens and electric limes
  const G = function (x, y, t) {
    return Math.floor(
      180
      + 75
      * Math.sin((x * x * Math.cos(t / 3) + y * y * Math.sin(t / 2)) / 250),
    )
  }

  // Blue channel: Electric blues and deep purples
  const B = function (x, y, t) {
    return Math.floor(
      200
      + 55
      * Math.sin(
        3 * Math.sin(t / 8)
        + ((x - 100) * (x - 100) + (y - 100) * (y - 100)) / 800,
      ),
    )
  }

  /*
   * RISOGRAPH MESH CREATION
   */

  // Create a more organic mesh with higher resolution for smoother risograph
  // effects
  const geometry = new THREE.PlaneGeometry(
    window.innerWidth / 1.5,
    500,
    120,
    120,
  )

  // Create material with risograph shader
  const material = new THREE.ShaderMaterial({
    uniforms: {
      // Risograph-style color palette - vibrant and saturated
      u_bg: { type: 'v3', value: rgb(255, 245, 235) }, // Cream paper background
      u_bgMain: { type: 'v3', value: rgb(250, 240, 230) }, // Slightly darker paper
      u_color1: { type: 'v3', value: rgb(255, 70, 150) }, // Hot pink ink
      u_color2: { type: 'v3', value: rgb(50, 255, 120) }, // Electric green ink
      u_time: { type: 'f', value: 30 }, // Animation time counter
      u_randomisePosition: { type: 'v2', value: randomisePosition }, // Organic movement offset
    },
    // Combine noise shader with our risograph fragment shader
    fragmentShader: sNoiseShader + risographFragmentShader,
    // Use same vertex shader for mesh distortion
    vertexShader: sNoiseShader + vertexShader,
  })

  /*
   * MESH POSITIONING AND SCALING
   */

  // Create the mesh (geometry + material)
  const mesh = new THREE.Mesh(geometry, material)

  // Position for optimal risograph viewing
  mesh.position.set(-100, 200, -250) // Less extreme positioning
  mesh.scale.multiplyScalar(3.5) // Slightly smaller for better composition

  // Subtle rotation for organic feel
  mesh.rotationX = -0.8 // Less tilted
  mesh.rotationY = 0.0
  mesh.rotationZ = 0.05 // Very slight roll

  // Add the mesh to our 3D scene
  scene.add(mesh)

  /*
   * PIXELATE POST-PROCESSING SETUP
   * Enhanced for risograph print texture
   */

  // Create material for the pixelate effect with stronger intensity for print
  // feel
  const pixelateMaterial = new THREE.ShaderMaterial({
    uniforms: {
      tDiffuse: { value: null }, // Will hold the original rendered image
      u_resolution: {
        value: new THREE.Vector2(window.innerWidth, window.innerHeight),
      }, // Screen size
      intensity: { value: 0.4 }, // Stronger pixelation for print texture
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

  // Color animation variables for risograph color cycling
  let x = randomInteger(0, 32)
  const y = randomInteger(0, 32)

  /*
   * MAIN ANIMATION LOOP
   * Enhanced for risograph print aesthetics
   */
  const animate = function () {
    requestAnimationFrame(animate) // Schedule next frame

    /*
     * TWO-PASS RENDERING
     * Pass 1: Render risograph gradient to texture
     * Pass 2: Apply pixelate effect and render to screen
     */

    // PASS 1: Render the risograph scene to our render target texture
    renderer.setRenderTarget(renderTarget)
    renderer.render(scene, camera)

    // PASS 2: Apply pixelate effect to the captured texture
    pixelateMaterial.uniforms.tDiffuse.value = renderTarget.texture

    // Render the pixelated result to the actual screen
    renderer.setRenderTarget(null)
    renderer.render(postScene, postCamera)

    /*
     * UPDATE SHADER UNIFORMS
     * Send new values to our risograph shaders each frame
     */

    // Update organic movement with slower, more print-like motion
    mesh.material.uniforms.u_randomisePosition.value = new THREE.Vector2(
      j * 0.5,
      j * 0.5,
    )

    // Update ink colors using our vibrant risograph color functions
    mesh.material.uniforms.u_color1.value = new THREE.Vector3(
      R(x, y, t / 3), // Slower color changes for print-like feel
      G(x, y, t / 3),
      B(x, y, t / 3),
    )

    // Update time for shader animations
    mesh.material.uniforms.u_time.value = t

    /*
     * RISOGRAPH COLOR CYCLING
     * Slower, more deliberate color transitions like changing ink cartridges
     */
    if (t % 0.15 === 0) {
      // Slower color changes for print aesthetic
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
     * Slower timing for print-like feel
     */
    j = j + 0.008 // Slower organic movement
    t = t + 0.04 // Slower main time increment
  }

  // Start the animation loop
  animate()
})
</script>

<template>
  <!--
    RISOGRAPH CANVAS CONTAINER
    This div holds our Three.js canvas for the risograph print simulation
  -->
  <div ref="canvasContainer" class="absolute top-0 left-0 h-full w-full" />
</template>
