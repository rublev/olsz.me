<script setup lang="ts">
import { useMediaQuery } from '@vueuse/core'
import { onMounted, onUnmounted, ref } from 'vue'

const SCROLL_TOP_THRESHOLD = 10
const DIRECTION_THRESHOLD = 30

type ScrollDirection = 'up' | 'down' | null

const isCollapsed = ref(false)
const lastScrollY = ref(0)

const textFading = ref(false)

const scrollAccumulator = ref(0)
const currentDirection = ref<ScrollDirection>(null)

const isDesktop = useMediaQuery('(min-width: 768px)')

function collapse() {
  if (isCollapsed.value)
    return

  textFading.value = true
  isCollapsed.value = true
}

function expand() {
  if (!isCollapsed.value)
    return

  textFading.value = false
  isCollapsed.value = false
}

function handleScroll() {
  // Skip collapse/expand on desktop
  if (isDesktop.value)
    return

  const currentScrollY = window.scrollY

  // at top? always expand
  if (currentScrollY <= 0 && isCollapsed.value) {
    scrollAccumulator.value = 0
    expand()
    lastScrollY.value = currentScrollY
    return
  }

  const scrollDelta = currentScrollY - lastScrollY.value

  // figure out scroll direction
  let intendedDirection: ScrollDirection = null
  if (scrollDelta > 0)
    intendedDirection = 'down'
  else if (scrollDelta < 0)
    intendedDirection = 'up'

  // direction changed, reset accumulator
  if (intendedDirection && intendedDirection !== currentDirection.value) {
    scrollAccumulator.value = 0
    currentDirection.value = intendedDirection
  }

  // scroll distance accumulator
  if (intendedDirection) {
    scrollAccumulator.value += Math.abs(scrollDelta)
  }

  // trigger if moved enough
  if (scrollAccumulator.value >= DIRECTION_THRESHOLD) {
    scrollAccumulator.value = 0

    if (
      currentDirection.value === 'down'
      && !isCollapsed.value
      && currentScrollY > SCROLL_TOP_THRESHOLD
    ) {
      collapse()
    }
    else if (currentDirection.value === 'up' && isCollapsed.value) {
      expand()
    }
  }

  lastScrollY.value = currentScrollY
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<template>
  <div
    class="
      fixed inset-x-0 right-0 bottom-0 left-0 z-1001 flex flex-col items-center
      bg-black px-8 pt-0 pb-4 font-gohu transition-opacity duration-600
      md:relative md:bg-transparent md:p-4 md:opacity-100 md:before:hidden
    "
    :class="[isCollapsed ? 'opacity-0' : 'opacity-100']"
  >
    <!-- Pixelated gradient above header (mobile only) -->
    <PixelatedBorder
      mode="gradient"
      color="#000000"
      sides="bottom"
      class="bottom-full"
    />

    <div
      class="
        flex w-full items-center justify-between
        md:max-w-2xl md:px-4
      "
    >
      <header class="flex items-center justify-start gap-3">
        <div
          class="
            flex items-center justify-start gap-3 transition-opacity
            duration-1000 ease-in-out
          "
          :class="[textFading ? 'opacity-0' : 'opacity-100']"
        >
          <SocialLinks mobile />
        </div>
      </header>
      <header
        class="
          flex items-center justify-start gap-3 text-white
          md:w-auto
        "
      >
        <div
          class="
            shrink-0 items-center justify-start gap-3 transition-opacity
            duration-1000 ease-in-out
            md:gap-4
          "
          :class="[textFading ? 'opacity-0' : 'opacity-100']"
        >
          <nav
            class="
              flex items-center gap-2
              md:gap-4
            "
          >
            <a
              href="/resume.pdf"
              target="_blank"
              class="
                font-pressstart font-light text-matrix transition-all
                duration-200
                hover:text-pink-500
              "
            >
              résumé
            </a>
          </nav>
        </div>
      </header>
    </div>
  </div>
</template>
