<script setup lang="ts">
import { onMounted, ref } from 'vue'
import logoColorSvg from '@/assets/icons/logo-color.svg?raw'

const originalRef = ref(null)
const downscale4Ref = ref(null)
const downscale8Ref = ref(null)
const downscale16Ref = ref(null)
const manual8Ref = ref(null)
const manual16Ref = ref(null)

async function loadSVGAsImage(): Promise<HTMLImageElement> {
  // Create a blob from the imported SVG text
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
    img.onerror = (e) => {
      console.error('Image load error:', e)
      reject(e)
    }
    img.src = url
  })
}

function drawOriginal(canvas: HTMLCanvasElement, img: HTMLImageElement) {
  const ctx = canvas.getContext('2d')
  if (!ctx)
    return
  canvas.width = 200
  canvas.height = 200
  ctx.drawImage(img, 0, 0, 200, 200)
}

function pixelateDownscale(
  canvas: HTMLCanvasElement,
  img: HTMLImageElement,
  pixelSize: number,
) {
  const ctx = canvas.getContext('2d')
  if (!ctx)
    return
  canvas.width = 200
  canvas.height = 200

  // Disable image smoothing for pixelated effect
  ctx.imageSmoothingEnabled = false

  const smallWidth = canvas.width / pixelSize
  const smallHeight = canvas.height / pixelSize

  // Create temporary canvas to draw small version
  const tempCanvas = document.createElement('canvas')
  const tempCtx = tempCanvas.getContext('2d')
  if (!tempCtx)
    return
  tempCanvas.width = smallWidth
  tempCanvas.height = smallHeight

  // Draw image small
  tempCtx.drawImage(img, 0, 0, smallWidth, smallHeight)

  // Scale it back up to main canvas
  ctx.drawImage(
    tempCanvas,
    0,
    0,
    smallWidth,
    smallHeight,
    0,
    0,
    canvas.width,
    canvas.height,
  )
}

function pixelateManual(
  canvas: HTMLCanvasElement,
  img: HTMLImageElement,
  blockSize: number,
) {
  const ctx = canvas.getContext('2d')
  if (!ctx)
    return
  canvas.width = 200
  canvas.height = 200

  // First draw the image normally
  ctx.drawImage(img, 0, 0, 200, 200)

  // Get image data
  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height)
  const data = imageData.data

  // Clear canvas
  ctx.clearRect(0, 0, canvas.width, canvas.height)

  // Sample and draw blocks
  for (let y = 0; y < canvas.height; y += blockSize) {
    for (let x = 0; x < canvas.width; x += blockSize) {
      // Sample the color at the block's top-left corner
      const pixelIndex = (y * canvas.width + x) * 4
      const r = data[pixelIndex] ?? 0
      const g = data[pixelIndex + 1] ?? 0
      const b = data[pixelIndex + 2] ?? 0
      const a = data[pixelIndex + 3] ?? 255

      ctx.fillStyle = `rgba(${r}, ${g}, ${b}, ${a / 255})`
      ctx.fillRect(x, y, blockSize, blockSize)
    }
  }
}

onMounted(async () => {
  try {
    const img = await loadSVGAsImage()

    // Original
    if (originalRef.value) {
      drawOriginal(originalRef.value, img)
    }

    // Downscale method with different pixel sizes
    if (downscale4Ref.value) {
      pixelateDownscale(downscale4Ref.value, img, 4)
    }
    if (downscale8Ref.value) {
      pixelateDownscale(downscale8Ref.value, img, 8)
    }
    if (downscale16Ref.value) {
      pixelateDownscale(downscale16Ref.value, img, 16)
    }

    // Manual pixel sampling method
    if (manual8Ref.value) {
      pixelateManual(manual8Ref.value, img, 8)
    }
    if (manual16Ref.value) {
      pixelateManual(manual16Ref.value, img, 16)
    }
  }
  catch (error) {
    console.error('Error loading SVG:', error)
  }
})
</script>

<template>
  <div class="container mx-auto py-12">
    <div
      class="
        grid grid-cols-1 gap-8
        md:grid-cols-2
        lg:grid-cols-3
      "
    >
      <!-- original -->
      <div class="bg-black p-6">
        <h2 class="mb-4 text-xl font-semibold text-white">
          Original
        </h2>
        <p class="mb-2 text-sm text-gray-400">
          No pixelation
        </p>
        <canvas ref="originalRef" class="w-full" />
      </div>

      <!-- Downscale Method - 4x -->
      <div class="bg-black p-6">
        <h2 class="mb-4 text-xl font-semibold text-white">
          Downscale Method (4x)
        </h2>
        <p class="mb-2 text-sm text-gray-400">
          Mild pixelation
        </p>
        <canvas ref="downscale4Ref" class="w-full" />
      </div>

      <!-- Downscale Method - 8x -->
      <div class="bg-black p-6">
        <h2 class="mb-4 text-xl font-semibold text-white">
          Downscale Method (8x)
        </h2>
        <p class="mb-2 text-sm text-gray-400">
          Medium pixelation
        </p>
        <canvas ref="downscale8Ref" class="w-full" />
      </div>

      <!-- Downscale Method - 16x -->
      <div class="bg-black p-6">
        <h2 class="mb-4 text-xl font-semibold text-white">
          Downscale Method (16x)
        </h2>
        <p class="mb-2 text-sm text-gray-400">
          Heavy pixelation
        </p>
        <canvas ref="downscale16Ref" class="w-full" />
      </div>

      <!-- Manual Sampling - 8px blocks -->
      <div class="bg-black p-6">
        <h2 class="mb-4 text-xl font-semibold text-white">
          Manual Sampling (8px)
        </h2>
        <p class="mb-2 text-sm text-gray-400">
          Block-based pixelation
        </p>
        <canvas ref="manual8Ref" class="w-full" />
      </div>

      <!-- Manual Sampling - 16px blocks -->
      <div class="bg-black p-6">
        <h2 class="mb-4 text-xl font-semibold text-white">
          Manual Sampling (16px)
        </h2>
        <p class="mb-2 text-sm text-gray-400">
          Large block pixelation
        </p>
        <canvas ref="manual16Ref" class="w-full" />
      </div>
    </div>

    <div class="mt-12 bg-black p-6 text-white">
      <h2 class="mb-4 text-2xl font-bold">
        Method Comparison
      </h2>
      <div class="space-y-4">
        <div>
          <h3 class="mb-2 text-lg font-semibold">
            Downscale Method
          </h3>
          <ul class="list-disc space-y-1 pl-6 text-gray-300">
            <li>Uses imageSmoothingEnabled = false</li>
            <li>Draws to small temp canvas, then scales up</li>
            <li>Smoother edges, better for gradients</li>
            <li>Better performance</li>
          </ul>
        </div>
        <div>
          <h3 class="mb-2 text-lg font-semibold">
            Manual Sampling Method
          </h3>
          <ul class="list-disc space-y-1 pl-6 text-gray-300">
            <li>Samples color from each block</li>
            <li>Fills rectangular blocks</li>
            <li>More "retro" chunky pixel look</li>
            <li>More control over appearance</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>
