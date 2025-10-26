<script setup lang="ts">
import { computed } from 'vue'
import { useResponsivePixelSize } from '~/composables/useResponsivePixelSize'

// Type definitions
type Mode = 'vignette' | 'gradient'
type Side = 'top' | 'bottom' | 'left' | 'right'

interface Props {
  mode?: Mode
  color?: string
  debug?: boolean
  pixelSize?: number
  sides?: string // For gradient mode: space-separated sides like "top left" or "all"
  class?: string
  inline?: boolean // Use inline flow positioning instead of absolute
}

// Props with defaults
const props = withDefaults(defineProps<Props>(), {
  mode: 'vignette',
  color: '#010b14',
  sides: 'all',
  debug: false,
  class: '',
  inline: false,
})

// Composables
const { pixelSize: responsivePixelSize, debugColor } = useResponsivePixelSize()

// Computed values
const effectivePixelSize = computed(
  () => props.pixelSize ?? responsivePixelSize.value,
)
const effectiveColor = computed(() =>
  props.debug ? debugColor.value : props.color,
)

// Opacity arrays: vignette fades out, gradient fades in
const opacities = computed(() =>
  props.mode === 'vignette'
    ? [1.0, 0.85, 0.7, 0.55, 0.4, 0.25]
    : [0.25, 0.4, 0.55, 0.7, 0.85, 1.0],
)

// Parse sides for gradient mode
const activeSides = computed<Set<Side>>(() => {
  // Vignette mode always uses all sides
  if (props.mode === 'vignette') {
    return new Set(['top', 'bottom', 'left', 'right'])
  }

  // Gradient mode parses space-separated sides
  if (props.sides === 'all') {
    return new Set(['top', 'bottom', 'left', 'right'])
  }

  const sides = props.sides.toLowerCase().split(/\s+/).filter(Boolean)
  return new Set(
    sides.filter(s =>
      ['top', 'bottom', 'left', 'right'].includes(s),
    ) as Side[],
  )
})

// Helper to check if a side is active
const hasSide = (side: Side) => activeSides.value.has(side)

// Convert hex color to rgba
function toRgba(hex: string, alpha: number): string {
  const r = Number.parseInt(hex.slice(1, 3), 16)
  const g = Number.parseInt(hex.slice(3, 5), 16)
  const b = Number.parseInt(hex.slice(5, 7), 16)
  return `rgba(${r}, ${g}, ${b}, ${alpha})`
}
</script>

<template>
  <!-- Vignette Mode: Border-based effect on all sides -->
  <div
    v-if="mode === 'vignette'"
    class="
      pointer-events-none fixed inset-0 mx-auto max-w-[calc(100vh*1.5)]
      xl:min-w-7xl
    "
    :class="props.class"
  >
    <div
      v-for="(opacity, i) in opacities"
      :key="i"
      class="absolute"
      :style="{
        inset: `${i * effectivePixelSize}px`,
        borderTop: `${effectivePixelSize}px solid ${toRgba(effectiveColor, opacity)}`,
        borderBottom: `${effectivePixelSize}px solid ${toRgba(effectiveColor, opacity)}`,
        borderLeft: `${effectivePixelSize}px solid ${toRgba(effectiveColor, opacity)}`,
        borderRight: `${effectivePixelSize}px solid ${toRgba(effectiveColor, opacity)}`,
      }"
    />
  </div>

  <!-- Gradient Mode: Stacked divs on specified sides -->
  <template v-else>
    <!-- Top Gradient -->
    <div
      v-if="hasSide('top')"
      class="pointer-events-none"
      :class="[
        props.inline ? 'relative w-full' : 'absolute inset-x-0 top-0',
        props.class,
      ]"
      :style="{ height: `${opacities.length * effectivePixelSize}px` }"
    >
      <div
        v-for="(opacity, i) in opacities.slice().reverse()"
        :key="i"
        class="absolute inset-x-0"
        :style="{
          top: `${i * effectivePixelSize}px`,
          height: `${effectivePixelSize}px`,
          background: toRgba(effectiveColor, opacity),
        }"
      />
    </div>

    <!-- Bottom Gradient -->
    <div
      v-if="hasSide('bottom')"
      class="pointer-events-none"
      :class="[
        props.inline ? 'relative w-full' : 'absolute inset-x-0 bottom-0',
        props.class,
      ]"
      :style="{ height: `${opacities.length * effectivePixelSize}px` }"
    >
      <div
        v-for="(opacity, i) in opacities.slice().reverse()"
        :key="i"
        class="absolute inset-x-0"
        :style="{
          bottom: `${i * effectivePixelSize}px`,
          height: `${effectivePixelSize}px`,
          background: toRgba(effectiveColor, opacity),
        }"
      />
    </div>

    <!-- Left Gradient -->
    <div
      v-if="hasSide('left')"
      class="pointer-events-none"
      :class="[
        props.inline ? 'relative h-full' : 'absolute inset-y-0 left-0',
        props.class,
      ]"
      :style="{ width: `${opacities.length * effectivePixelSize}px` }"
    >
      <div
        v-for="(opacity, i) in opacities.slice().reverse()"
        :key="i"
        class="absolute inset-y-0"
        :style="{
          left: `${i * effectivePixelSize}px`,
          width: `${effectivePixelSize}px`,
          background: toRgba(effectiveColor, opacity),
        }"
      />
    </div>

    <!-- Right Gradient -->
    <div
      v-if="hasSide('right')"
      class="pointer-events-none"
      :class="[
        props.inline ? 'relative h-full' : 'absolute inset-y-0 right-0',
        props.class,
      ]"
      :style="{ width: `${opacities.length * effectivePixelSize}px` }"
    >
      <div
        v-for="(opacity, i) in opacities.slice().reverse()"
        :key="i"
        class="absolute inset-y-0"
        :style="{
          right: `${i * effectivePixelSize}px`,
          width: `${effectivePixelSize}px`,
          background: toRgba(effectiveColor, opacity),
        }"
      />
    </div>
  </template>
</template>
