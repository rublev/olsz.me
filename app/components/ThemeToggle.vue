<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'

const isDark = ref(false)
const isReady = ref(false)
const isScrolled = ref(false)

// Fade between sun and moon
const sunOpacity = computed(() => (isDark.value ? 0 : 1))
const moonOpacity = computed(() => (isDark.value ? 1 : 0))

// Conditional z-index based on scroll
const zIndex = computed(() => (isScrolled.value ? 'z-450' : 'z-1050'))

// Lower opacity and grayscale when not clickable (underneath content)
const buttonStyle = computed(() => ({
  opacity: isScrolled.value ? 0.75 : 1,
  filter: isScrolled.value ? 'grayscale(100%)' : 'grayscale(0%)',
}))

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

function handleScroll() {
  isScrolled.value = window.scrollY > 200
}

onMounted(() => {
  // Initialize isDark from current state
  isDark.value = document.documentElement.classList.contains('dark')
  isReady.value = true

  // Add scroll listener
  window.addEventListener('scroll', handleScroll, { passive: true })
  // Check initial scroll position
  handleScroll()
})

onBeforeUnmount(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<template>
  <button
    v-if="isReady"
    class="fixed top-8 right-8 cursor-pointer transition-all duration-600"
    :class="zIndex"
    :style="buttonStyle"
    @click="toggleTheme"
  >
    <div class="relative block">
      <!-- Sun (light mode) -->
      <Icon
        name="svg:sun"
        class="h-8 w-8 transition-all duration-700"
        :class="isDark ? 'text-pink-500' : 'text-yellow-500'"
        :style="{ opacity: sunOpacity }"
        style="shape-rendering: crispEdges"
      />
      <!-- Moon (dark mode - fades in on top) -->
      <Icon
        name="svg:moon"
        class="
          absolute inset-0 h-8 w-8 text-pink-500 transition-opacity duration-700
        "
        :style="{ opacity: moonOpacity }"
        style="shape-rendering: crispEdges"
      />
    </div>
  </button>
</template>
