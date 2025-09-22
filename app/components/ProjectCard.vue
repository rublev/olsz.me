<script setup>
import { computed, ref } from 'vue'

defineProps({
  href: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  initials: {
    type: String,
    required: true,
  },
  iconBgClass: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    required: true,
  },
  period: {
    type: String,
    required: true,
  },
})

const tiltStyle = ref('')
const textParallaxStyle = ref('')
const isHovered = ref(false)

// unified timing for animation syncing
const cardTransition = computed(() => ({
  transition: 'all 600ms cubic-bezier(0.25, 0.46, 0.45, 0.94)',
}))

const textTransition = computed(() => ({
  transition: textParallaxStyle.value
    ? 'transform 100ms ease-out'
    : 'transform 600ms cubic-bezier(0.25, 0.46, 0.45, 0.94)',
}))

function handleMouseMove(event) {
  // only apply tilt on desktop (screen width > 640px)
  if (window.innerWidth <= 640)
    return

  const card = event.currentTarget
  if (!card)
    return

  const rect = card.getBoundingClientRect()
  const centerX = rect.left + rect.width / 2
  const centerY = rect.top + rect.height / 2

  const mouseX = event.clientX
  const mouseY = event.clientY

  // clamp rotation values for smoothness
  const rotateX = Math.max(-15, Math.min(15, (mouseY - centerY) / rect.height * -20))
  const rotateY = Math.max(-15, Math.min(15, (mouseX - centerX) / rect.width * 20))

  // card tilt with proper transform-origin
  tiltStyle.value = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(1.08) translateZ(0)`

  // text parallax - smoother movement
  const parallaxX = (mouseX - centerX) / rect.width * 8
  const parallaxY = (mouseY - centerY) / rect.height * 8
  textParallaxStyle.value = `translate3d(${parallaxX}px, ${parallaxY}px, 30px)`
}

function handleMouseEnter() {
  isHovered.value = true
}

function handleMouseLeave() {
  isHovered.value = false
  tiltStyle.value = ''
  textParallaxStyle.value = ''
}
</script>

<template>
  <a
    :href="href"
    target="_blank"
    :style="{
      ...cardTransition,
      transform: tiltStyle,
      transformOrigin: 'center center',
      transformStyle: 'preserve-3d',
    }"
    class="
      group flex min-w-full flex-1 flex-col overflow-hidden rounded-lg border
      border-white/15 p-4
      hover:relative hover:z-10 hover:cursor-alias hover:border
      hover:border-white hover:bg-transparent
      hover:shadow-[2px_2px_0px_0px_rgb(255,255,255),2px_3px_0px_0px_rgb(255,255,255)]
      sm:h-[140px] sm:min-w-[198px]
    "
    @mouseenter="handleMouseEnter"
    @mousemove="handleMouseMove"
    @mouseleave="handleMouseLeave"
  >
    <div
      class="mb-6 flex items-center gap-4"
      :style="{
        ...textTransition,
        transform: textParallaxStyle,
      }"
    >
      <span
        class="
          text-lg leading-none font-semibold text-white transition-all
          duration-[600ms] ease-[cubic-bezier(0.25,0.46,0.45,0.94)]
          group-hover:text-white group-hover:brightness-110
          group-hover:drop-shadow-[0_0_12px_rgba(255,255,255,0.8)]
        "
        style="
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          transform: translateZ(0);
          backface-visibility: hidden;
        "
      >{{ title }}</span>
    </div>
    <div
      class="relative mt-auto flex flex-col justify-end"
      :style="{
        ...textTransition,
        transform: textParallaxStyle,
      }"
    >
      <p
        class="
          text-sm text-gray-200 transition-all duration-[600ms]
          ease-[cubic-bezier(0.25,0.46,0.45,0.94)]
          group-hover:-translate-y-6 group-hover:text-gray-100
          group-hover:brightness-110
          group-hover:drop-shadow-[0_0_6px_rgba(255,255,255,0.4)]
        "
        style="
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          transform: translateZ(0);
          backface-visibility: hidden;
        "
      >{{ role }}</p>
      <span
        class="
          absolute bottom-0 left-0 translate-y-6 font-mono text-xs text-gray-300
          opacity-0 transition-all duration-[600ms]
          ease-[cubic-bezier(0.25,0.46,0.45,0.94)]
          group-hover:translate-y-0 group-hover:text-gray-100
          group-hover:opacity-100 group-hover:brightness-110
          group-hover:drop-shadow-[0_0_6px_rgba(255,255,255,0.4)]
        "
        style="
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          transform: translateZ(0);
          backface-visibility: hidden;
        "
      >{{ period }}</span>
    </div>
  </a>
</template>
