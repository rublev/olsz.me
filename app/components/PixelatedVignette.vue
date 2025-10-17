<script setup>
import { onMounted, onUnmounted, ref } from 'vue'

const props = defineProps({
  pixelSize: {
    type: Number,
    default: 8,
  },
  intensity: {
    type: Number,
    default: 0.6, // 0 to 1, how dark the edges are
  },
  color: {
    type: String,
    default: '#000000',
  },
})

const canvasRef = ref(null)

function createVignetteGradient(width, height, intensity, color) {
  // Create a temporary canvas for the gradient
  const tempCanvas = document.createElement('canvas')
  const tempCtx = tempCanvas.getContext('2d')
  tempCanvas.width = width
  tempCanvas.height = height

  // Parse color to RGB for gradient stops
  const hexToRgb = (hex) => {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
    return result
      ? {
          r: Number.parseInt(result[1], 16),
          g: Number.parseInt(result[2], 16),
          b: Number.parseInt(result[3], 16),
        }
      : null
  }

  const rgb = hexToRgb(color) || { r: 0, g: 0, b: 0 }

  // Create squircle/rectangular vignette by drawing from edges
  const imageData = tempCtx.createImageData(width, height)
  const data = imageData.data

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const index = (y * width + x) * 4

      // Calculate normalized distance from edges (0 at edge, 1 at center)
      const distX = Math.min(x / width, (width - x) / width) * 2
      const distY = Math.min(y / height, (height - y) / height) * 2

      // Use minimum to create rectangular shape
      const edgeDist = Math.min(distX, distY)

      let alpha = 0

      if (edgeDist < 0.02) {
        // Very thin outer edge - solid black
        alpha = 1
        data[index] = 0
        data[index + 1] = 0
        data[index + 2] = 0
      }
      else if (edgeDist < 0.3) {
        // Middle ring - colored vignette fading in from black
        const t = (edgeDist - 0.02) / (0.3 - 0.02)

        // Blend from black to color
        if (t < 0.3) {
          // Still mostly black, transitioning to color
          const blackToColor = t / 0.3
          alpha = 1 - (1 - intensity) * blackToColor
          data[index] = rgb.r * blackToColor
          data[index + 1] = rgb.g * blackToColor
          data[index + 2] = rgb.b * blackToColor
        }
        else {
          // Fading from color to transparent
          const fadeOut = (t - 0.3) / 0.7
          alpha = intensity * (1 - fadeOut)
          data[index] = rgb.r
          data[index + 1] = rgb.g
          data[index + 2] = rgb.b
        }
      }
      else {
        // Center - transparent
        alpha = 0
        data[index] = 0
        data[index + 1] = 0
        data[index + 2] = 0
      }

      data[index + 3] = alpha * 255
    }
  }

  tempCtx.putImageData(imageData, 0, 0)
  return tempCanvas
}

function pixelateVignette() {
  if (!canvasRef.value)
    return

  const canvas = canvasRef.value
  const ctx = canvas.getContext('2d')

  // Set canvas to full viewport size
  const width = window.innerWidth
  const height = window.innerHeight

  canvas.width = width
  canvas.height = height

  // Create the gradient vignette
  const vignetteCanvas = createVignetteGradient(
    width,
    height,
    props.intensity,
    props.color,
  )

  // Disable image smoothing for pixelated effect
  ctx.imageSmoothingEnabled = false

  const smallWidth = Math.ceil(width / props.pixelSize)
  const smallHeight = Math.ceil(height / props.pixelSize)

  // Create small temp canvas
  const tempCanvas = document.createElement('canvas')
  const tempCtx = tempCanvas.getContext('2d')
  tempCanvas.width = smallWidth
  tempCanvas.height = smallHeight
  tempCtx.imageSmoothingEnabled = false

  // Draw vignette small
  tempCtx.drawImage(vignetteCanvas, 0, 0, smallWidth, smallHeight)

  // Scale back up for pixelated effect
  ctx.drawImage(tempCanvas, 0, 0, smallWidth, smallHeight, 0, 0, width, height)
}

let resizeTimeout = null
function handleResize() {
  // Debounce resize events
  clearTimeout(resizeTimeout)
  resizeTimeout = setTimeout(() => {
    pixelateVignette()
  }, 100)
}

onMounted(() => {
  pixelateVignette()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  clearTimeout(resizeTimeout)
})
</script>

<template>
  <canvas
    ref="canvasRef"
    class="pointer-events-none fixed inset-0 z-50"
    style="image-rendering: pixelated"
  />
</template>
