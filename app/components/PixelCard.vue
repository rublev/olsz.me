<script setup lang="ts">
const props = defineProps({
  /**
   * Size of each pixel step in pixels
   */
  step: {
    type: Number,
    default: 4,
  },
  /**
   * Number of steps in each corner (1 = single indent, 3+ = staircase)
   */
  steps: {
    type: Number,
    default: 1,
  },
  /**
   * Border width in pixels
   */
  borderWidth: {
    type: Number,
    default: 0,
  },
  /**
   * Border color
   */
  borderColor: {
    type: String,
    default: 'currentColor',
  },
})

// Generate clip-path polygon for pixelated border with multiple steps
const clipPath = computed(() => {
  const s = props.step
  const n = props.steps
  const points: string[] = []

  // Start at top-left, going clockwise

  // Top-left corner: going UP and RIGHT
  for (let i = n - 1; i >= 0; i--) {
    points.push(`${(n - i - 1) * s}px ${(i + 1) * s}px`) // horizontal
    points.push(`${(n - i) * s}px ${(i + 1) * s}px`) // move right
    if (i > 0) {
      points.push(`${(n - i) * s}px ${i * s}px`) // move up
    }
  }

  // Top edge: left to right
  points.push(`calc(100% - ${n * s}px) 0`)

  // Top-right corner: going RIGHT and DOWN
  for (let i = 0; i < n; i++) {
    points.push(`calc(100% - ${(n - i - 1) * s}px) ${i * s}px`) // move right
    points.push(`calc(100% - ${(n - i - 1) * s}px) ${(i + 1) * s}px`) // move down
    if (i < n - 1) {
      points.push(`calc(100% - ${(n - i - 2) * s}px) ${(i + 1) * s}px`) // move right
    }
  }

  // Right edge: top to bottom
  points.push(`100% calc(100% - ${n * s}px)`)

  // Bottom-right corner: going DOWN and LEFT
  for (let i = n - 1; i >= 0; i--) {
    points.push(
      `calc(100% - ${(n - i - 1) * s}px) calc(100% - ${(i + 1) * s}px)`,
    ) // move down
    points.push(`calc(100% - ${(n - i) * s}px) calc(100% - ${(i + 1) * s}px)`) // move left
    if (i > 0) {
      points.push(`calc(100% - ${(n - i) * s}px) calc(100% - ${i * s}px)`) // move down
    }
  }

  // Bottom edge: right to left
  points.push(`${n * s}px 100%`)

  // Bottom-left corner: going LEFT and UP
  for (let i = 0; i < n; i++) {
    points.push(`${(n - i - 1) * s}px calc(100% - ${i * s}px)`) // move left
    points.push(`${(n - i - 1) * s}px calc(100% - ${(i + 1) * s}px)`) // move up
    if (i < n - 1) {
      points.push(`${(n - i - 2) * s}px calc(100% - ${(i + 1) * s}px)`) // move left
    }
  }

  return `polygon(${points.join(', ')})`
})
</script>

<template>
  <div
    :style="{
      clipPath,
      border:
        borderWidth > 0 ? `${borderWidth}px solid ${borderColor}` : 'none',
    }"
  >
    <slot />
  </div>
</template>

<style scoped>
div {
  image-rendering: pixelated;
  shape-rendering: crispEdges;
}
</style>
