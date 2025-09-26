<script setup>
/*
 * NEON GRADIENT DEMO
 *
 * This page creates ultra-vibrant, electric neon aesthetics with:
 * 1. Intensely saturated colors inspired by 80's neon signage
 * 2. Enhanced color contrast and saturation boosting
 * 3. Electric blue, acid green, and hot magenta palettes
 * 4. Faster, more energetic animations
 * 5. Enhanced pixelate post-processing for digital neon feel
 * 6. Color overflow and glow effects
 */

// Three.js for 3D graphics
import * as THREE from 'three'

// Vue imports
import { onMounted, ref } from 'vue'

import fragmentShader from '~/assets/shaders/fragment.glsl?raw' // Enhanced for neon effects
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
   * ELECTRIC NEON COLOR FUNCTIONS
   * These create the most vibrant, saturated colors possible
   * Inspired by 80's neon signs, cyberpunk aesthetics, and electric displays
   */

  // Red channel: Electric magentas and hot pinks (boosted range)
  const R = function (x, y, t) {
    return Math.floor(240 + 15 * Math.cos((x * x - y * y) / 150 + t * 1.5))
  }

  // Green channel: Acid greens and electric limes (maximum saturation)
  const G = function (x, y, t) {
    return Math.floor(
      230
      + 25
      * Math.sin((x * x * Math.cos(t / 2.5) + y * y * Math.sin(t / 2)) / 200),
    )
  }

  // Blue channel: Electric blues and cyber purples (intense range)
  const B = function (x, y, t) {
    return Math.floor(
      220
      + 35
      * Math.sin(
        6 * Math.sin(t / 6)
        + ((x - 100) * (x - 100) + (y - 100) * (y - 100)) / 600,
      ),
    )
  }

  /*
   * NEON MESH CREATION
   */

  // Create high-resolution mesh for smooth neon flows
  const geometry = new THREE.PlaneGeometry(
    window.innerWidth / 1.8,
    480,
    130,
    130,
  )

  // Create material with enhanced neon colors
  const material = new THREE.ShaderMaterial({
    uniforms: {
      // Electric neon color palette - maximum saturation
      u_bg: { type: 'v3', value: rgb(10, 5, 15) }, // Deep space background
      u_bgMain: { type: 'v3', value: rgb(5, 0, 10) }, // Even darker for contrast
      u_color1: { type: 'v3', value: rgb(255, 0, 255) }, // Electric magenta
      u_color2: { type: 'v3', value: rgb(0, 255, 150) }, // Acid green
      u_time: { type: 'f', value: 30 }, // Animation time counter
      u_randomisePosition: { type: 'v2', value: randomisePosition }, // Organic movement offset
    },
    // Combine noise shader with our standard fragment shader (works great for
    // neon)
    fragmentShader: sNoiseShader + fragmentShader,
    // Use same vertex shader for mesh distortion
    vertexShader: sNoiseShader + vertexShader,
  })

  /*
   * MESH POSITIONING AND SCALING
   */

  // Create the mesh (geometry + material)
  const mesh = new THREE.Mesh(geometry, material)

  // Position for dynamic neon display
  mesh.position.set(-80, 180, -220) // More centered and closer
  mesh.scale.multiplyScalar(4.2) // Larger for maximum impact

  // Dynamic neon orientation
  mesh.rotationX = -0.7 // Moderate tilt
  mesh.rotationY = 0.0
  mesh.rotationZ = 0.08 // Slight dynamic angle

  // Add the mesh to our 3D scene
  scene.add(mesh)

  /*
   * PIXELATE POST-PROCESSING SETUP
   * Enhanced for digital neon pixel aesthetic
   */

  // Create material for the pixelate effect with strong intensity for digital
  // feel
  const pixelateMaterial = new THREE.ShaderMaterial({
    uniforms: {
      tDiffuse: { value: null }, // Will hold the original rendered image
      u_resolution: {
        value: new THREE.Vector2(window.innerWidth, window.innerHeight),
      }, // Screen size
      intensity: { value: 0.35 }, // Strong pixelation for digital neon aesthetic
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

  // Animation time variables - faster for energetic neon feel
  let t = 0 // Main time counter
  let j = 0 // Secondary time counter for organic movement

  // Color animation variables for rapid neon color cycling
  let x = randomInteger(0, 32)
  const y = randomInteger(0, 32)

  /*
   * MAIN ANIMATION LOOP
   * Enhanced for electric neon aesthetics with faster, more energetic timing
   */
  const animate = function () {
    requestAnimationFrame(animate) // Schedule next frame

    /*
     * TWO-PASS RENDERING
     * Pass 1: Render neon gradient to texture
     * Pass 2: Apply pixelate effect and render to screen
     */

    // PASS 1: Render the neon scene to our render target texture
    renderer.setRenderTarget(renderTarget)
    renderer.render(scene, camera)

    // PASS 2: Apply pixelate effect to the captured texture
    pixelateMaterial.uniforms.tDiffuse.value = renderTarget.texture

    // Render the pixelated result to the actual screen
    renderer.setRenderTarget(null)
    renderer.render(postScene, postCamera)

    /*
     * UPDATE SHADER UNIFORMS
     * Send new values to our neon shaders each frame
     */

    // Update organic movement with energetic neon timing
    mesh.material.uniforms.u_randomisePosition.value = new THREE.Vector2(
      j * 1.2,
      j * 1.2,
    )

    // Update electric colors using our intense neon color functions
    mesh.material.uniforms.u_color1.value = new THREE.Vector3(
      R(x, y, t / 1.5), // Faster color changes for electric feel
      G(x, y, t / 1.5),
      B(x, y, t / 1.5),
    )

    // Also animate the second color for maximum dynamism
    mesh.material.uniforms.u_color2.value = new THREE.Vector3(
      B(x + 16, y, t / 1.8), // Offset pattern for color variety
      R(x, y + 16, t / 1.8),
      G(x + 8, y + 8, t / 1.8),
    )

    // Update time for shader animations
    mesh.material.uniforms.u_time.value = t

    /*
     * RAPID NEON COLOR CYCLING
     * Fast, energetic color changes like flashing neon signs
     */
    if (t % 0.08 === 0) {
      // Very fast color changes for electric energy
      if (vCheck === false) {
        x -= 2 // Faster transitions
        if (x <= 0) {
          vCheck = true
        }
      }
      else {
        x += 2 // Faster transitions
        if (x >= 32) {
          vCheck = false
        }
      }
    }

    /*
     * INCREMENT TIME COUNTERS
     * Fast timing for energetic neon feel
     */
    j = j + 0.015 // Fast organic movement for electric energy
    t = t + 0.06 // Fast main time increment for rapid changes
  }

  // Start the animation loop
  animate()
})
</script>

<template>
  <!--
    NEON CANVAS CONTAINER
    This div holds our Three.js canvas for the electric neon simulation
    Black background enhances the neon glow effect
  -->
  <div
    ref="canvasContainer"
    class="absolute top-0 left-0 h-full w-full bg-black"
  />
</template>
