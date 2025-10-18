<script setup lang="ts">
import html2canvas from 'html2canvas' // uninstalled this
import * as THREE from 'three'
import { onMounted, onUnmounted, ref } from 'vue'

const overlayCanvas = ref(null)
let renderer, scene, camera, mesh

// Pixelation shader
const PixelShader = {
  uniforms: {
    tDiffuse: { value: null },
    resolution: { value: new THREE.Vector2(1920, 1080) },
    pixelSize: { value: 8.0 },
  },
  vertexShader: `
    varying vec2 vUv;
    void main() {
      vUv = uv;
      gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0);
    }
  `,
  fragmentShader: `
    uniform sampler2D tDiffuse;
    uniform vec2 resolution;
    uniform float pixelSize;
    varying vec2 vUv;
    void main() {
      vec2 dxy = pixelSize / resolution;
      vec2 coord = dxy * floor(vUv / dxy);
      gl_FragColor = texture2D(tDiffuse, coord);
    }
  `,
}

function initShader(texture) {
  if (typeof window === 'undefined')
    return

  renderer = new THREE.WebGLRenderer({ canvas: overlayCanvas.value })
  renderer.setSize(window.innerWidth, window.innerHeight)

  scene = new THREE.Scene()
  camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1)

  const material = new THREE.ShaderMaterial({
    uniforms: {
      tDiffuse: { value: texture },
      resolution: {
        value: new THREE.Vector2(window.innerWidth, window.innerHeight),
      },
      pixelSize: { value: 8.0 },
    },
    vertexShader: PixelShader.vertexShader,
    fragmentShader: PixelShader.fragmentShader,
  })

  mesh = new THREE.Mesh(new THREE.PlaneGeometry(2, 2), material)
  scene.add(mesh)

  renderer.render(scene, camera)
}

function handleResize() {
  if (renderer && mesh) {
    renderer.setSize(window.innerWidth, window.innerHeight)
    mesh.material.uniforms.resolution.value.set(
      window.innerWidth,
      window.innerHeight,
    )
    renderer.render(scene, camera)
  }
}

onMounted(() => {
  // Take snapshot of body, then feed to shader
  html2canvas(document.body).then((canvas) => {
    const tex = new THREE.CanvasTexture(canvas)
    tex.minFilter = THREE.NearestFilter
    tex.magFilter = THREE.NearestFilter
    initShader(tex)
  })

  if (typeof window !== 'undefined') {
    window.addEventListener('resize', handleResize)
  }
})

onUnmounted(() => {
  if (renderer) {
    renderer.dispose()
  }
  if (typeof window !== 'undefined') {
    window.removeEventListener('resize', handleResize)
  }
})
</script>

<template>
  <div class="min-h-screen bg-gradient-to-br from-yellow-200 to-blue-200">
    <div class="p-12 text-2xl">
      <h1 class="mb-4 text-4xl font-bold">
        Hello World
      </h1>
      <p class="mb-4">
        This is normal DOM text and images.
      </p>
      <img
        src="https://picsum.photos/400/200"
        alt="Random image"
        class="rounded-lg shadow-lg"
      >
    </div>

    <canvas
      ref="overlayCanvas"
      class="pointer-events-none fixed top-0 left-0 z-50 h-full w-full"
    />
  </div>
</template>
