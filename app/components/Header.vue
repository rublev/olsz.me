<script setup>
import { onMounted, onUnmounted, ref } from 'vue'

// animation timing constants
const WIDTH_SHRINK_DELAY = 0
const EXPAND_TEXT_DELAY = 0
const SCROLL_TOP_THRESHOLD = 10
const DIRECTION_THRESHOLD = 30

const isScrolled = ref(false)
const isCollapsed = ref(false)
const headerRef = ref(null)
const lastScrollY = ref(0)
const scrollThreshold = ref(0)
const naturalWidth = ref() // natural width
const originalNaturalWidth = ref() // natural width

// social
const socialRef = ref()
const socialNaturalWidth = ref()
const socialOriginalNaturalWidth = ref()

// staggered animation states
const textFading = ref(false)
const widthShrinking = ref(false)

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
    isAnimating.value = false
  }, WIDTH_SHRINK_DELAY)

  animationTimeouts.value.push(timeout1)
  isCollapsed.value = true
}

function expand() {
  if (!isCollapsed.value || isAnimating.value)
    return

  // clear pending animations
  clearAnimationTimeouts()
  isAnimating.value = true

  widthShrinking.value = false

  const timeout = setTimeout(() => {
    textFading.value = false
    isAnimating.value = false
  }, EXPAND_TEXT_DELAY)

  animationTimeouts.value.push(timeout)
  isCollapsed.value = false
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

    if (currentDirection.value === 'down' && !isCollapsed.value && currentScrollY > SCROLL_TOP_THRESHOLD) {
      collapse()
    }
    else if (currentDirection.value === 'up' && isCollapsed.value) {
      expand()
    }
  }

  lastScrollY.value = currentScrollY
}

function measureWidth(refElement, varNames) {
  if (!refElement.value)
    return

  const names = Array.isArray(varNames) ? varNames : [varNames]
  const width = refElement.value.scrollWidth

  names.forEach((varName) => {
    varName.value = width
  })
}

onMounted(async () => {
  window.addEventListener('scroll', handleScroll)
  measureWidth(headerRef, [naturalWidth, originalNaturalWidth])
  measureWidth(socialRef, [socialNaturalWidth, socialOriginalNaturalWidth])
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  clearAnimationTimeouts()
})
</script>

<template>
  <div
    class="
      fixed inset-x-0 bottom-0 z-20 h-20 bg-gradient-to-t from-black
      to-transparent transition-opacity duration-600
    "
    :class="[isCollapsed ? 'opacity-0' : 'opacity-100']"
  >
    <header
      ref="headerRef"
      class="
        fixed bottom-4 left-4 z-30 flex items-center justify-start rounded-full
        font-inter text-white
      "
      :style="{
        width: widthShrinking
          ? '0px'
          : `${naturalWidth}px`,
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
      </div>
    </header>
    <header
      ref="socialRef"
      class="
        fixed right-4 bottom-4 z-30 flex items-center justify-start rounded-full
        font-inter text-white
      "
      :style="{
        width: widthShrinking
          ? '0px'
          : `${socialNaturalWidth}px`,
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
            border-red-500 leading-none transition-all duration-200
            hover:text-blue-200
          "
        >
          <Icon name="mdi:linkedin" class="h-5 w-5" />
        </a>
        <a
          href="https://github.com/marcelolszewski"
          target="_blank"
          class="
            border-red-500 leading-none transition-all duration-200
            hover:text-blue-200
          "
        >
          <Icon name="mdi:github" class="h-5 w-5" />
        </a>
        <a
          href="https://app.10xmanagement.com/clients/marcel-olszewski-16302/profile"
          target="_blank"
          class="
            border-red-500 leading-none transition-all duration-200
            hover:text-blue-200
          "
        >
          <Icon name="svg:logo-10x" class="h-5" />
        </a>
      </div>
    </header>
  </div>
</template>
