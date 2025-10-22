<script setup>
import { computed, onMounted, ref } from 'vue'
import GLYPHS from '@/assets/glyphs.json'

const isDark = ref(false)
const isReady = ref(false)

// Fade between sun and moon
const sunOpacity = computed(() => (isDark.value ? 0 : 1))
const moonOpacity = computed(() => (isDark.value ? 1 : 0))

function toggleTheme() {
  isDark.value = !isDark.value
  const newTheme = isDark.value ? 'dark' : 'light'

  sessionStorage.setItem('theme', newTheme)

  if (isDark.value) {
    document.documentElement.classList.add('dark')
  }
  else {
    document.documentElement.classList.remove('dark')
  }
}

onMounted(() => {
  // Initialize isDark from current state
  isDark.value = document.documentElement.classList.contains('dark')
  isReady.value = true
})
</script>

<template>
  <button
    v-if="isReady"
    class="
      fixed top-8 right-8 z-[40] cursor-pointer font-mondwest text-4xl
      hover:cursor-pointer
    "
    @click="toggleTheme"
  >
    <span class="relative block">
      <!-- Sun (light mode) -->
      <span
        class="transition-all duration-700"
        :class="isDark ? 'text-pink-500' : 'text-yellow-500'"
        :style="{ opacity: sunOpacity }"
      >
        {{ GLYPHS.mondwest.sun_filled }}
      </span>
      <!-- Moon (dark mode - fades in on top) -->
      <span
        class="absolute inset-0 text-pink-500 transition-opacity duration-700"
        :style="{ opacity: moonOpacity }"
      >
        {{ GLYPHS.mondwest.moon_left }}
      </span>
    </span>
  </button>
</template>
