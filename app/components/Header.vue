<script setup lang="ts">
import { useMediaQuery } from '@vueuse/core'
import { onMounted, onUnmounted, ref } from 'vue'

const SCROLL_TOP_THRESHOLD = 10
const DIRECTION_THRESHOLD = 30

type ScrollDirection = 'up' | 'down' | null

const isCollapsed = ref(false)
const headerRef = ref(null)
const socialRef = ref(null)
const lastScrollY = ref(0)
const naturalWidth = ref()
const socialNaturalWidth = ref()

const textFading = ref(false)
const widthShrinking = ref(false)

const scrollAccumulator = ref(0)
const currentDirection = ref<ScrollDirection>(null)

const isDesktop = useMediaQuery('(min-width: 768px)')

// THEME SWITCHER
const isDark = ref(false)

/* function toggleTheme() {
  isDark.value = !isDark.value
  const newTheme = isDark.value ? 'dark' : 'light'

  sessionStorage.setItem('theme', newTheme)

  if (isDark.value) {
    document.documentElement.classList.add('dark')
  }
  else {
    document.documentElement.classList.remove('dark')
  }
} */

function collapse() {
  if (isCollapsed.value)
    return

  textFading.value = true
  widthShrinking.value = true
  isCollapsed.value = true
}

function expand() {
  if (!isCollapsed.value)
    return

  widthShrinking.value = false
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

function measureWidth(refElement: Ref<HTMLElement | null>) {
  return refElement.value?.scrollWidth
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  naturalWidth.value = measureWidth(headerRef)
  socialNaturalWidth.value = measureWidth(socialRef)

  // Initialize isDark from current state
  isDark.value = document.documentElement.classList.contains('dark')
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<template>
  <div
    class="
      fixed inset-x-0 right-0 bottom-0 left-0 z-20 flex flex-col items-center
      bg-navy px-4 pt-0 pb-4 font-gohu transition-opacity duration-600
      md:relative md:bg-transparent md:p-4 md:opacity-100 md:before:hidden
    "
    :class="[isCollapsed ? 'opacity-0' : 'opacity-100']"
  >
    <!-- Pixelated gradient above header (mobile only) -->
    <PixelatedHeaderGradient
      :pixel-size="8"
      :height="40"
      :intensity="1"
      color="#010b14"
      class="md:hidden"
    />

    <div
      class="
        flex w-full items-center justify-between
        md:max-w-2xl md:px-4
      "
    >
      <header
        ref="socialRef"
        class=""
        :style="{
          width: isDesktop
            ? 'auto'
            : widthShrinking
              ? '0px'
              : socialNaturalWidth
                ? `${socialNaturalWidth}px`
                : 'auto',
          gap: widthShrinking ? '0' : '8px',
          transition: 'all 400ms ease-in-out',
        }"
      >
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
        ref="headerRef"
        class="
          flex items-center justify-start text-white
          md:w-auto
        "
        :style="{
          width: isDesktop
            ? 'auto'
            : widthShrinking
              ? '0px'
              : naturalWidth
                ? `${naturalWidth}px`
                : 'auto',
          gap: widthShrinking ? '0' : '8px',
          transition: 'all 400ms ease-in-out',
        }"
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
              href="/resume"
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
