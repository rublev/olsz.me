<script setup>
import { useMediaQuery } from '@vueuse/core'
import { onMounted, onUnmounted, ref } from 'vue'
import GLYPHS from '@/assets/glyphs.json'

const SCROLL_TOP_THRESHOLD = 10
const DIRECTION_THRESHOLD = 30

const isCollapsed = ref(false)
const headerRef = ref(null)
const socialRef = ref(null)
const lastScrollY = ref(0)
const naturalWidth = ref()
const socialNaturalWidth = ref()

const textFading = ref(false)
const widthShrinking = ref(false)

const scrollAccumulator = ref(0)
const currentDirection = ref(null)

const isDesktop = useMediaQuery('(min-width: 768px)')

// THEME SWITCHER
const isDark = ref(false)

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
  let intendedDirection = null
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

    if (currentDirection.value === 'down' && !isCollapsed.value && currentScrollY > SCROLL_TOP_THRESHOLD) {
      collapse()
    }
    else if (currentDirection.value === 'up' && isCollapsed.value) {
      expand()
    }
  }

  lastScrollY.value = currentScrollY
}

function measureWidth(refElement) {
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
      fixed inset-x-0 right-0 bottom-0 left-0 z-20 flex h-15 flex-col
      items-center bg-black px-8 transition-opacity duration-600
      before:pointer-events-none before:absolute before:inset-x-0
      before:bottom-15 before:h-10 before:bg-gradient-to-b
      before:from-transparent before:to-black before:content-['']
      md:relative md:bg-transparent md:p-4 md:opacity-100 md:before:hidden
    "
    :class="[isCollapsed ? 'opacity-0' : 'opacity-100']"
  >
    <div
      class="
        flex h-15 w-full items-center justify-between
        md:max-w-2xl md:px-4
      "
    >
      <header
        ref="headerRef"
        class="
          flex items-center justify-start rounded-full text-white
          md:w-auto
        "
        :style="{
          width: isDesktop ? 'auto' : (widthShrinking ? '0px' : (naturalWidth ? `${naturalWidth}px` : 'auto')),
          gap: widthShrinking ? '0' : '8px',
          transition: 'all 400ms ease-in-out',
        }"
      >
        <div
          class="
            flex items-center justify-start gap-3 transition-opacity
            duration-[1000ms] ease-in-out
            md:gap-4
          "
          :class="[textFading ? 'opacity-0' : 'opacity-100']"
        >
          <a href="/" class="flex shrink-0 items-center">
            <PixelatedLogo :height="22" :pixel-size="4" />
            <!-- <Icon
              mode="css"
              name="svg:logo-color"
              class="!h-5 !w-5 !mask-contain"
            /> -->
          </a>
          <nav
            class="
              flex items-center gap-2
              md:gap-4
            "
          >
            <a
              href="/resume"
              class="
                transition-all duration-200
                hover:text-pink-500
              "
            >
              Resume
            </a>
            <a
              href="/contact"
              class="
                transition-all duration-200
                hover:text-pink-500
              "
            >
              Contact
            </a>
          </nav>
        </div>
      </header>
      <header
        ref="socialRef"
        class="
          flex items-center justify-start rounded-full text-white
          md:w-auto
        "
        :style="{
          width: isDesktop ? 'auto' : (widthShrinking ? '0px' : (socialNaturalWidth ? `${socialNaturalWidth}px` : 'auto')),
          gap: widthShrinking ? '0' : '8px',
          transition: 'all 400ms ease-in-out',
        }"
      >
        <div
          class="
            flex items-center justify-start gap-3 overflow-hidden
            transition-opacity duration-[1000ms] ease-in-out
          "
          :class="[textFading ? 'opacity-0' : 'opacity-100']"
        >
          <a
            href="https://linkedin.com/in/marcelolszewski"
            target="_blank"
            class="
              h-5 w-5 border-red-500 leading-none transition-all duration-200
              hover:text-pink-500
            "
          >
            <Icon
              mode="css"
              name="mdi:linkedin"
              class="!h-5 !w-5 !mask-contain"
            />
          </a>
          <a
            href="https://github.com/marcelolszewski"
            target="_blank"
            class="
              border-red-500 leading-none transition-all duration-200
              hover:text-pink-500
            "
          >
            <Icon name="mdi:github" class="h-5 w-5" />
          </a>
          <a
            href="https://app.10xmanagement.com/clients/marcel-olszewski-16302/profile"
            target="_blank"
            class="
              border-red-500 leading-none transition-all duration-200
              hover:text-pink-500
            "
          >
            <Icon name="svg:logo-10x" class="h-5" />
          </a>
          <span class="text-gray-500">
            |
          </span>
          <button
            class="
              font-mondwest text-4xl text-white transition-all duration-200
              hover:text-pink-500
            "
            @click="toggleTheme"
          >
            {{ isDark ? GLYPHS.mondwest.sun_empty : GLYPHS.mondwest.sun_filled }}
          </button>
        </div>
      </header>
    </div>
  </div>
</template>
