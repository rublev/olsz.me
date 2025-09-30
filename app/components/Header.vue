<script setup>
import { onMounted, onUnmounted, ref } from 'vue'

// animation timing constants
const WIDTH_SHRINK_DELAY = 500
const CHEVRON_SHOW_DELAY = 2000
const EXPAND_TEXT_DELAY = 500
const SCROLL_TOP_THRESHOLD = 200
const DIRECTION_THRESHOLD = 30
const MEASURE_WIDTH_DELAY = 500

const isScrolled = ref(false)
const isCollapsed = ref(false)
const headerRef = ref(null)
const naturalWidth = ref() // fallback
const lastScrollY = ref(0)
const scrollThreshold = ref(0)

// staggered animation states
const textFading = ref(false)
const widthShrinking = ref(false)
const chevronVisible = ref(false)

// animation control
const animationTimeouts = ref([])
const isAnimating = ref(false)

// track scroll direction with threshold
const scrollAccumulator = ref(0)
const currentDirection = ref(null) // up/down/null

function clearAnimationTimeouts() {
  animationTimeouts.value.forEach(timeout => clearTimeout(timeout))
  animationTimeouts.value = []
}

function collapse() {
  if (isCollapsed.value || isAnimating.value)
    return

  // clear pending animations
  clearAnimationTimeouts()
  isAnimating.value = true

  textFading.value = true

  const timeout1 = setTimeout(() => {
    widthShrinking.value = true
  }, WIDTH_SHRINK_DELAY)

  const timeout2 = setTimeout(() => {
    chevronVisible.value = true
    isAnimating.value = false
  }, CHEVRON_SHOW_DELAY)

  animationTimeouts.value.push(timeout1, timeout2)
  isCollapsed.value = true
}

function expand() {
  if (!isCollapsed.value || isAnimating.value)
    return

  // clear pending animations
  clearAnimationTimeouts()
  isAnimating.value = true

  chevronVisible.value = false
  widthShrinking.value = false

  const timeout = setTimeout(() => {
    textFading.value = false
    isAnimating.value = false
  }, EXPAND_TEXT_DELAY)

  animationTimeouts.value.push(timeout)
  isCollapsed.value = false
}

function toggleMenu(event) {
  event.preventDefault()
  event.stopPropagation()

  if (isCollapsed.value) {
    expand()
  }
  else {
    collapse()
  }
}

function handleScroll() {
  isScrolled.value = window.scrollY > scrollThreshold.value

  const currentScrollY = window.scrollY

  // at top? always expand
  if (currentScrollY <= scrollThreshold.value && isCollapsed.value) {
    // cancel animation and force expand
    clearAnimationTimeouts()
    isAnimating.value = false
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

  // trigger if moved enough and not animating
  if (scrollAccumulator.value >= DIRECTION_THRESHOLD && !isAnimating.value) {
    scrollAccumulator.value = 0

    if (currentScrollY > SCROLL_TOP_THRESHOLD) {
      if (currentDirection.value === 'down' && !isCollapsed.value) {
        collapse()
      }
      else if (currentDirection.value === 'up' && isCollapsed.value) {
        expand()
      }
    }
  }

  lastScrollY.value = currentScrollY
}

onMounted(async () => {
  window.addEventListener('scroll', handleScroll)

  // wait for render then measure width - social links always rendered now
  await new Promise(resolve => setTimeout(resolve, MEASURE_WIDTH_DELAY))
  if (headerRef.value) {
    naturalWidth.value = headerRef.value.scrollWidth
  }
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)

  // cleanup timers
  clearAnimationTimeouts()
})
</script>

<template>
  <header
    ref="headerRef"
    class="
      fixed bottom-4 left-1/2 z-30 flex -translate-x-1/2 items-center
      justify-center rounded-full bg-[#5553] text-white backdrop-blur
    "
    :style="{
      width: widthShrinking
        ? '48px'
        : naturalWidth
          ? `${naturalWidth}px`
          : 'auto',
      padding: widthShrinking ? '8px' : '16px',
      gap: widthShrinking ? '0' : '8px',
      transition: 'all 400ms ease-in-out',
    }"
  >
    <Transition
      enter-active-class="transition-opacity duration-500 ease-out"
      leave-active-class="transition-opacity duration-300 ease-in"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <button
        v-if="chevronVisible"
        class="
          absolute inset-0 flex touch-manipulation items-center justify-center
        "
        @click="toggleMenu"
      >
        <Icon name="mdi:chevron-up" mode="css" class="h-4 w-4" />
      </button>
    </Transition>

    <div
      class="
        flex items-center gap-3 overflow-hidden transition-opacity
        duration-[1000ms] ease-out
      "
      :class="[textFading ? 'opacity-0' : 'opacity-100']"
    >
      <a href="/" class="flex items-center">
        <Icon name="svg:logo-color" class="h-[22px]" />
      </a>
      <nav class="flex items-center gap-2">
        <a
          href="/resume"
          class="
            transition-all duration-200
            hover:text-blue-200
          "
        >
          Resume
        </a>
        <a
          href="/contact"
          class="
            transition-all duration-200
            hover:text-blue-200
          "
        >
          Contact
        </a>
      </nav>
      <nav class="flex gap-2">
        <a
          href="https://app.10xmanagement.com/clients/marcel-olszewski-16302/profile"
          target="_blank"
          class="
            border-red-500 leading-none transition-all duration-200
            hover:text-blue-200
          "
        >
          10x
        </a>
        <a
          href="https://linkedin.com/in/marcelolszewski"
          target="_blank"
          class="
            border-red-500 leading-none transition-all duration-200
            hover:text-blue-200
          "
        >
          <Icon mode="css" name="mdi:linkedin" class="h-4 w-4" />
        </a>
        <a
          href="https://github.com/marcelolszewski"
          target="_blank"
          class="
            border-red-500 leading-none transition-all duration-200
            hover:text-blue-200
          "
        >
          <Icon mode="css" name="mdi:github" class="h-4 w-4" />
        </a>
      </nav>
    </div>
  </header>
</template>
