<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'

const BREAKPOINTS = {
  SM: 640,
  MD: 768,
  XL: 1280,
}

const SPACING = {
  DEFAULT: 24,
  SM: 30,
  MD: 36,
  XL: 42,
}

const BUTTON_HEIGHT = 32
const CONTAINER_ASPECT_RATIO = 1.5
const XL_MIN_WIDTH = 1280

const { isDark, toggleTheme } = useTheme()

const isReady = ref(false)
const isColliding = ref(false)
const isMobile = ref(false)
const viewportWidth = ref(0)
const viewportHeight = ref(0)

const shouldFade = computed(() => isMobile.value && isColliding.value)

const spacing = computed(() => {
  const vw = viewportWidth.value

  if (vw >= BREAKPOINTS.XL)
    return { top: SPACING.XL, right: SPACING.XL }
  if (vw >= BREAKPOINTS.MD)
    return { top: SPACING.MD, right: SPACING.MD }
  if (vw >= BREAKPOINTS.SM)
    return { top: SPACING.SM, right: SPACING.SM }

  return { top: SPACING.DEFAULT, right: SPACING.DEFAULT }
})

const containerWidth = computed(() => {
  const vw = viewportWidth.value
  const vh = viewportHeight.value

  let width = vh * CONTAINER_ASPECT_RATIO

  if (vw >= BREAKPOINTS.XL)
    width = Math.max(width, XL_MIN_WIDTH)

  return Math.min(width, vw)
})

const position = computed(() => {
  const vw = viewportWidth.value
  const { top, right } = spacing.value

  const sideGap
    = containerWidth.value < vw ? (vw - containerWidth.value) / 2 : 0

  return {
    top: `${top}px`,
    right: `${right + sideGap}px`,
  }
})

const style = computed(() => ({
  ...position.value,
  opacity: shouldFade.value ? 0.75 : 1,
  filter: shouldFade.value ? 'grayscale(100%)' : 'none',
  zIndex: shouldFade.value ? 450 : 1050,
}))

function checkCollision() {
  if (!isMobile.value) {
    isColliding.value = false
    return
  }

  const mobileHeader = document.querySelector('[data-mobile-header]')
  if (!mobileHeader)
    return

  const headerRect = mobileHeader.getBoundingClientRect()
  const buttonTop = spacing.value.top
  const buttonBottom = buttonTop + BUTTON_HEIGHT

  isColliding.value = headerRect.top <= buttonBottom
}

function updateViewport() {
  viewportWidth.value = window.innerWidth
  viewportHeight.value = window.innerHeight
  isMobile.value = window.innerWidth < BREAKPOINTS.MD

  if (!isMobile.value)
    isColliding.value = false
}

onMounted(() => {
  isReady.value = true
  updateViewport()
  checkCollision()

  window.addEventListener('resize', updateViewport, { passive: true })
  window.addEventListener('scroll', checkCollision, { passive: true })
})

onBeforeUnmount(() => {
  window.removeEventListener('scroll', checkCollision)
  window.removeEventListener('resize', updateViewport)
})
</script>

<template>
  <button
    v-if="isReady"
    data-theme-toggle
    :style="style"
    class="fixed cursor-pointer transition-all duration-600"
    @click="toggleTheme"
  >
    <div class="relative">
      <Icon
        name="svg:sun"
        :style="{ opacity: isDark ? 0 : 1 }"
        :class="isDark ? 'text-pink-500' : 'text-yellow-500'"
        class="h-8 w-8 transition-all duration-700"
        style="shape-rendering: crispEdges"
      />
      <Icon
        name="svg:moon"
        :style="{ opacity: isDark ? 1 : 0 }"
        class="
          absolute inset-0 h-8 w-8 text-pink-500 transition-opacity duration-700
        "
        style="shape-rendering: crispEdges"
      />
    </div>
  </button>
</template>
