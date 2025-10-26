<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'

const orpheusHeight = ref<string>('100vh')
const isDark = ref(false)
const dayImageRef = ref<HTMLImageElement | null>(null)
const nightImageRef = ref<HTMLImageElement | null>(null)
const isReady = ref(false)

// Keep day always visible, fade night in/out on top
const nightOpacity = computed(() => (isDark.value ? 1 : 0))

// Function to calculate and update orpheus height
function updateOrpheusHeight() {
  const temp = document.createElement('div')
  temp.style.height = '100lvh'
  temp.style.position = 'absolute'
  temp.style.visibility = 'hidden'
  document.body.appendChild(temp)

  const lvhHeight = temp.getBoundingClientRect().height
  document.body.removeChild(temp)

  orpheusHeight.value = `${lvhHeight}px`
}

onMounted(() => {
  // Initial height calculation
  updateOrpheusHeight()

  // Update height on window resize
  window.addEventListener('resize', updateOrpheusHeight)

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

onBeforeUnmount(() => {
  // Clean up resize listener
  window.removeEventListener('resize', updateOrpheusHeight)
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
          md:min-w-7xl
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
          md:min-w-7xl
        "
        :style="{
          imageRendering: 'pixelated',
          height: orpheusHeight,
          objectPosition: '75% center',
          opacity: nightOpacity,
        }"
      >
    </div>

    <!-- vignette working -->
    <PixelatedBorder
      mode="vignette"
      color="#000000"
      class="
        invisible z-1001
        xl:visible
      "
    />

    <PixelatedBorder
      mode="gradient"
      sides="left right"
      color="#000000"
      class="xl:invisible"
    />

    <!-- vignette color tests 2 -->
    <PixelatedBorder
      mode="gradient"
      color="#000000"
      sides="top"
      class="
        fixed z-1000
        xl:invisible
      "
    />

    <PixelatedBorder
      mode="gradient"
      color="#000000"
      sides="bottom"
      class="
        fixed z-999
        xl:invisible
      "
    />

    <Header class="md:hidden" />

    <!-- content -->
    <main
      class="
        inset-0 z-500 mx-auto flex items-start justify-center
        md:fixed
        xl:max-w-[calc(100vh*1.5)] xl:min-w-7xl
      "
      style="overflow: scroll"
    >
      <!-- Theme toggle -->
      <ThemeToggle />
      <div
        class="relative z-500 flex min-h-svh grow items-center justify-center"
      >
        <slot />
      </div>
    </main>

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
