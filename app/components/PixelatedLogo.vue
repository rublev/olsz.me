<script setup lang="ts">
import { onMounted, ref } from 'vue'
import logoColorSvg from '@/assets/icons/logo-color.svg?raw'

type PixelateFunction = (
  canvas: HTMLCanvasElement,
  img: HTMLImageElement,
  pixelSize: number,
  targetHeight: number,
) => void

const props = defineProps({
  pixelSize: {
    type: Number,
    default: 4,
  },
  height: {
    type: Number,
    default: 22,
  },
  method: {
    type: String,
    default: 'downscale',
  },
})

const canvasRef = ref(null)
const canvasWidth = ref(0)

async function loadSVGAsImage(): Promise<HTMLImageElement> {
  const blob = new Blob([logoColorSvg], {
    type: 'image/svg+xml;charset=utf-8',
  })
  const url = URL.createObjectURL(blob)

  return new Promise((resolve, reject) => {
    const img = new Image()
    img.onload = () => {
      URL.revokeObjectURL(url)
      resolve(img)
    }
    img.onerror = reject
    img.src = url
  })
}

// DOWNSCALE METHOD - smoother edges, better for gradients
const pixelateDownscale: PixelateFunction = (
  canvas,
  img,
  pixelSize,
  targetHeight,
) => {
  const ctx = canvas.getContext('2d')
  if (!ctx)
    return

  // SVG dimensions from viewBox: 70x41
  const svgWidth = 70
  const svgHeight = 41
  const aspectRatio = svgWidth / svgHeight

  const height = targetHeight
  const width = Math.ceil(height * aspectRatio)

  // Set canvas internal dimensions
  canvas.width = width
  canvas.height = height

  // Store width for CSS
  canvasWidth.value = width

  // Disable image smoothing for pixelated effect (no anti-aliasing)
  ctx.imageSmoothingEnabled = false

  const smallWidth = Math.ceil(width / pixelSize)
  const smallHeight = Math.ceil(height / pixelSize)

  // Create temporary canvas to draw small version
  const tempCanvas = document.createElement('canvas')
  const tempCtx = tempCanvas.getContext('2d')
  if (!tempCtx)
    return
  tempCanvas.width = smallWidth
  tempCanvas.height = smallHeight

  // Disable smoothing on temp canvas too
  tempCtx.imageSmoothingEnabled = false

  // Draw image small
  tempCtx.drawImage(img, 0, 0, smallWidth, smallHeight)

  // Scale it back up to main canvas (crisp pixels, no anti-aliasing)
  ctx.drawImage(tempCanvas, 0, 0, smallWidth, smallHeight, 0, 0, width, height)
}

// MANUAL SAMPLING METHOD - more "retro" chunky pixel look
const pixelateManual: PixelateFunction = (
  canvas,
  img,
  pixelSize,
  targetHeight,
) => {
  const ctx = canvas.getContext('2d')
  if (!ctx)
    return

  // SVG dimensions from viewBox: 70x41
  const svgWidth = 70
  const svgHeight = 41
  const aspectRatio = svgWidth / svgHeight

  const height = targetHeight
  const width = Math.ceil(height * aspectRatio)

  // Set canvas internal dimensions
  canvas.width = width
  canvas.height = height

  // Store width for CSS
  canvasWidth.value = width

  // First draw the image normally
  ctx.drawImage(img, 0, 0, width, height)

  // Get image data
  const imageData = ctx.getImageData(0, 0, width, height)
  const data = imageData.data

  // Clear canvas
  ctx.clearRect(0, 0, width, height)

  // Sample and draw blocks
  for (let y = 0; y < height; y += pixelSize) {
    for (let x = 0; x < width; x += pixelSize) {
      // Sample the color at the block's top-left corner
      const pixelIndex = (y * width + x) * 4
      const r = data[pixelIndex] ?? 0
      const g = data[pixelIndex + 1] ?? 0
      const b = data[pixelIndex + 2] ?? 0
      const a = data[pixelIndex + 3] ?? 255

      ctx.fillStyle = `rgba(${r}, ${g}, ${b}, ${a / 255})`
      ctx.fillRect(x, y, pixelSize, pixelSize)
    }
  }
}

onMounted(async () => {
  try {
    const img = await loadSVGAsImage()
    if (canvasRef.value) {
      if (props.method === 'manual') {
        pixelateManual(canvasRef.value, img, props.pixelSize, props.height)
      }
      else {
        pixelateDownscale(canvasRef.value, img, props.pixelSize, props.height)
      }
    }
  }
  catch (error) {
    console.error('Error loading pixelated logo:', error)
  }
})
</script>

<template>
  <canvas
    ref="canvasRef"
    :style="{
      width: `${canvasWidth}px`,
      height: `${height}px`,
      imageRendering: 'pixelated',
    }"
    class="block"
  />
</template>
