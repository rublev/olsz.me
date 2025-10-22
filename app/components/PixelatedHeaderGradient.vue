<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'

const props = defineProps({
  pixelSize: {
    type: Number,
    default: 8,
  },
  height: {
    type: Number,
    default: 120, // Height of the gradient in pixels
  },
  intensity: {
    type: Number,
    default: 0.075, // 0 to 1, how opaque the gradient is
  },
  color: {
    type: String,
    default: '#000000',
  },
})

const canvasRef = ref<HTMLCanvasElement | null>(null)

function createHeaderGradient(
  width: number,
  height: number,
  intensity: number,
  color: string,
) {
  // Create a temporary canvas for the gradient
  const tempCanvas = document.createElement('canvas')
  const tempCtx = tempCanvas.getContext('2d')
  if (!tempCtx)
    return tempCanvas
  tempCanvas.width = width
  tempCanvas.height = height

  // Parse color to RGB
  const hexToRgb = (hex: string) => {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
    return result
      ? {
          r: Number.parseInt(result[1]!, 16),
          g: Number.parseInt(result[2]!, 16),
          b: Number.parseInt(result[3]!, 16),
        }
      : null
  }

  const rgb = hexToRgb(color) || { r: 0, g: 0, b: 0 }

  // Create gradient: solid at top, transparent at bottom
  const imageData = tempCtx.createImageData(width, height)
  const data = imageData.data

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const index = (y * width + x) * 4

      // Calculate alpha based on vertical position
      // 0 (transparent) at top, intensity (solid) at bottom
      // Use exponential curve for more pronounced fade
      const normalizedY = y / height
      const alpha = normalizedY ** 0.5 * intensity

      data[index] = rgb.r
      data[index + 1] = rgb.g
      data[index + 2] = rgb.b
      data[index + 3] = alpha * 255
    }
  }

  tempCtx.putImageData(imageData, 0, 0)
  return tempCanvas
}

function pixelateGradient() {
  if (!canvasRef.value)
    return

  const canvas = canvasRef.value
  const ctx = canvas.getContext('2d')
  if (!ctx)
    return

  // Set canvas to full width, custom height
  const width = window.innerWidth
  const height = props.height

  canvas.width = width
  canvas.height = height

  // Create the gradient
  const gradientCanvas = createHeaderGradient(
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
  if (!tempCtx)
    return
  tempCanvas.width = smallWidth
  tempCanvas.height = smallHeight
  tempCtx.imageSmoothingEnabled = false

  // Draw gradient small
  tempCtx.drawImage(gradientCanvas, 0, 0, smallWidth, smallHeight)

  // Scale back up for pixelated effect
  ctx.drawImage(tempCanvas, 0, 0, smallWidth, smallHeight, 0, 0, width, height)
}

let resizeTimeout: ReturnType<typeof setTimeout> | null = null
function handleResize() {
  // Debounce resize events
  if (resizeTimeout)
    clearTimeout(resizeTimeout)
  resizeTimeout = setTimeout(() => {
    pixelateGradient()
  }, 100)
}

onMounted(() => {
  pixelateGradient()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  if (resizeTimeout)
    clearTimeout(resizeTimeout)
})
</script>

<template>
  <canvas
    ref="canvasRef"
    class="pointer-events-none absolute inset-x-0 bottom-full z-10"
    :style="`image-rendering: pixelated; height: ${height}px`"
  />
</template>
