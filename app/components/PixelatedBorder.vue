<script setup lang="ts">
import { computed } from 'vue'
import { useResponsivePixelSize } from '~/composables/useResponsivePixelSize'

const {
  pixelSize: defaultPixelSize,
  color = '#010b14',
  sides = 'all',
  mode = 'vignette',
  debug = false,
} = defineProps<{
  pixelSize?: number
  color?: string
  sides?:
    | 'all'
    | 'top'
    | 'bottom'
    | 'left'
    | 'right'
    | 'top-bottom'
    | 'left-right'
  mode?: 'vignette' | 'gradient'
  debug?: boolean
}>()

const { pixelSize: responsivePixelSize, debugColor } = useResponsivePixelSize()

// Use responsive pixel size if not explicitly provided
const effectivePixelSize = computed(
  () => defaultPixelSize ?? responsivePixelSize.value,
)
const effectiveColor = computed(() => (debug ? debugColor.value : color))

// Vignette uses decreasing opacity outward, gradient uses increasing opacity
const opacities
  = mode === 'vignette'
    ? [1.0, 0.85, 0.7, 0.55, 0.4, 0.25]
    : [0.25, 0.4, 0.55, 0.7, 0.85, 1.0]

function toRgba(hex: string, alpha: number) {
  const r = Number.parseInt(hex.slice(1, 3), 16)
  const g = Number.parseInt(hex.slice(3, 5), 16)
  const b = Number.parseInt(hex.slice(5, 7), 16)
  return `rgba(${r}, ${g}, ${b}, ${alpha})`
}

// Determine which sides to render
const showTop = sides === 'all' || sides === 'top' || sides === 'top-bottom'
const showBottom
  = sides === 'all' || sides === 'bottom' || sides === 'top-bottom'
const showLeft = sides === 'all' || sides === 'left' || sides === 'left-right'
const showRight
  = sides === 'all' || sides === 'right' || sides === 'left-right'
</script>

<template>
  <!-- Vignette mode: border-based -->
  <div
    v-if="mode === 'vignette'"
    class="
      pointer-events-none fixed inset-0 h-full
      xl:mx-auto xl:aspect-270/180 xl:w-auto xl:min-w-7xl
    "
  >
    <div
      v-for="(opacity, i) in opacities"
      :key="i"
      class="absolute"
      :style="{
        inset: `${i * effectivePixelSize}px`,
        borderTop: showTop
          ? `${effectivePixelSize}px solid ${toRgba(effectiveColor, opacity)}`
          : 'none',
        borderBottom: showBottom
          ? `${effectivePixelSize}px solid ${toRgba(effectiveColor, opacity)}`
          : 'none',
        borderLeft: showLeft
          ? `${effectivePixelSize}px solid ${toRgba(effectiveColor, opacity)}`
          : 'none',
        borderRight: showRight
          ? `${effectivePixelSize}px solid ${toRgba(effectiveColor, opacity)}`
          : 'none',
      }"
    />
  </div>

  <!-- Gradient mode: stacked divs -->
  <div
    v-else
    class="pointer-events-none absolute inset-x-0 bottom-full z-10"
    :style="{ height: `${opacities.length * effectivePixelSize}px` }"
  >
    <div
      v-for="(opacity, i) in opacities"
      :key="i"
      class="absolute inset-x-0"
      :style="{
        top: `${i * effectivePixelSize}px`,
        height: `${effectivePixelSize}px`,
        background: toRgba(effectiveColor, opacity),
      }"
    />
  </div>
</template>
