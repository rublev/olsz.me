<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'

const orpheusHeight = ref<string>('100vh')
const isDark = ref(false)
const dayImageRef = ref<HTMLImageElement | null>(null)
const nightImageRef = ref<HTMLImageElement | null>(null)
const isReady = ref(false)

// Keep day always visible, fade night in/out on top
const nightOpacity = computed(() => (isDark.value ? 1 : 0))

onMounted(() => {
  // Create a temporary element to measure 100lvh (large viewport height)
  const temp = document.createElement('div')
  temp.style.height = '100lvh'
  temp.style.position = 'absolute'
  temp.style.visibility = 'hidden'
  document.body.appendChild(temp)

  // Get the computed height in pixels
  const lvhHeight = temp.getBoundingClientRect().height
  document.body.removeChild(temp)

  // Lock to this pixel value so it never changes
  orpheusHeight.value = `${lvhHeight}px`

  // Initialize dark mode state
  isDark.value = document.documentElement.classList.contains('dark')

  // Watch for dark mode changes
  const observer = new MutationObserver(() => {
    isDark.value = document.documentElement.classList.contains('dark')
  })

  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['class'],
  })

  // Wait for both animations to load before fading out overlay
  let dayLoaded = false
  let nightLoaded = false

  const checkReady = () => {
    if (dayLoaded && nightLoaded) {
      isReady.value = true
    }
  }

  if (dayImageRef.value) {
    if (dayImageRef.value.complete) {
      dayLoaded = true
      checkReady()
    }
    else {
      dayImageRef.value.addEventListener('load', () => {
        dayLoaded = true
        checkReady()
      })
    }
  }

  if (nightImageRef.value) {
    if (nightImageRef.value.complete) {
      nightLoaded = true
      checkReady()
    }
    else {
      nightImageRef.value.addEventListener('load', () => {
        nightLoaded = true
        checkReady()
      })
    }
  }
})
</script>

<template>
  <div class="relative min-h-svh">
    <!-- background animations -->
    <div
      class="
        pointer-events-none fixed inset-0 z-0 flex items-start justify-center
      "
    >
      <!-- Day animation (light mode - always visible as base layer) -->
      <img
        ref="dayImageRef"
        src="/assets/animations/day.gif"
        alt=""
        class="
          w-auto object-cover
          md:min-w-[1280px]
        "
        :style="{
          imageRendering: 'pixelated',
          height: orpheusHeight,
          objectPosition: '75% center',
        }"
      >
      <!-- Night animation (dark mode - fades in on top) -->
      <img
        ref="nightImageRef"
        src="/assets/animations/night.gif"
        alt=""
        class="
          absolute left-1/2 w-auto -translate-x-1/2 object-cover
          transition-opacity duration-700
          md:min-w-[1280px]
        "
        :style="{
          imageRendering: 'pixelated',
          height: orpheusHeight,
          objectPosition: '75% center',
          opacity: nightOpacity,
        }"
      >

      <!-- vignette overlay pinned to orpheus -->
      <PixelatedVignette
        :pixel-size="8"
        :intensity="0.075"
        color="#000000"
      />
    </div>

    <!-- content -->
    <main
      class="
        relative z-400 flex min-h-svh grow items-center justify-center
        md:mr-12
      "
    >
      <Header class="md:hidden" />
      <slot />
      <!-- <Footer class="mt-auto" /> -->
    </main>

    <!-- Theme toggle -->
    <ThemeToggle />

    <!-- Loading overlay -->
    <div
      class="
        pointer-events-none fixed inset-0 z-50 bg-black transition-opacity
        duration-700
      "
      :style="{ opacity: isReady ? 0 : 1 }"
    />
  </div>
</template>
