<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
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
  brandColor: {
    type: String,
    required: true,
  },
  isActive: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits(['hover', 'unhover'])

// timing stuff
const ANIMATION_DURATION = 600 // how long animations take
const ANIMATION_EASING = 'ease-out' // makes it feel smooth
const PARALLAX_SPEED = 8 // how much text moves around
const TILT_INTENSITY = 20 // how much the card tilts
const TILT_CLAMP = 15 // don't tilt too crazy
const CARD_SCALE = 1.08 // makes it bigger on hover
const PERSPECTIVE = 1200 // 3d stuff
const MOBILE_BREAKPOINT = 640 // desktop vs mobile
const TILT_DELAY = 100 // delay before tilt kicks in
const BRIGHTNESS_THRESHOLD = 0.75 // when to treat colors as bright

// visual tweaks
const GRADIENT_OPACITY_STRONG = 40 // main background fade
const GRADIENT_OPACITY_MEDIUM = 25 // secondary fade
const GRADIENT_OPACITY_LIGHT = 20 // subtle fade
const BORDER_OPACITY_DEFAULT = 15 // default border see-through
const LIGHTING_OPACITY_STRONG = 60 // main light effect
const LIGHTING_OPACITY_MEDIUM = 30 // softer light
const TEXT_GLOW_SECONDARY = 15 // text glow size

// color constants
const DARK_BG_COLOR = '#222222'
const BLACK_BG_COLOR = '#000000'
const WHITE_TEXT_COLOR = 'rgb(255 255 255)'
const GRAY_TEXT_COLOR = 'rgb(180 180 180)'

// bright color opacity overrides
const BRIGHT_GRADIENT_STRONG = '80'
const BRIGHT_GRADIENT_LIGHT = '60'
const BRIGHT_GRADIENT_MEDIUM = '70'
const BRIGHT_GRADIENT_ALT = '85'
const DIM_GRADIENT_ALT = '35'

// filter effects
const HOVER_CONTRAST = '150%'
const HOVER_SATURATION = '120%'
const HOVER_BRIGHTNESS = '110%'
const DEFAULT_CONTRAST = '100%'
const TEXT_SHADOW_OFFSET = '1px'
const TEXT_SHADOW_BLUR = '1px'
const TEXT_SHADOW_COLOR = 'rgba(0 0 0 / 0.5)'

// state stuff
const tiltStyle = ref('')
const textParallaxStyle = ref('')
const lightingStyle = ref('')
const isHovered = ref(false)
const tiltEnabled = ref(false)
const tiltTimeout = ref(null)

const noisePattern = computed(() => {
  // simple hash from title for consistent randomness
  const seed = props.title
    .split('')
    .reduce((acc, char) => acc + char.charCodeAt(0), 0)
  // https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
  // GLSL noise algo stuff. hacky randomness
  const random1 = Math.sin(seed * 12.9898) * 43758.5453
  const random2 = Math.sin(seed * 78.233) * 43758.5453
  return {
    x: (random1 % 1) * 100,
    y: (random2 % 1) * 100,
    rotation: (random1 % 1) * 360,
  }
})

// figure out if the color is bright or dark
const colorBrightness = computed(() => {
  const hex = props.brandColor.replace('#', '')
  const r = Number.parseInt(hex.substring(0, 2), 16)
  const g = Number.parseInt(hex.substring(2, 4), 16)
  const b = Number.parseInt(hex.substring(4, 6), 16)
  // hardcoded luminance weights for brightness stuff
  // https://stackoverflow.com/questions/596216/formula-to-determine-perceived-brightness-of-rgb-color
  return (r * 0.299 + g * 0.587 + b * 0.114) / 255
})

// bright colors need different treatment
const isBrightColor = computed(
  () => colorBrightness.value > BRIGHTNESS_THRESHOLD,
)

// styles that change based on color brightness
const dynamicStyles = computed(() => ({
  borderColor: `rgba(255 255 255 / 0.${BORDER_OPACITY_DEFAULT})`,
  gradientBackground: `
    radial-gradient(circle at ${noisePattern.value.x}% ${noisePattern.value.y}%,
      ${props.brandColor}${isBrightColor.value ? BRIGHT_GRADIENT_STRONG : GRADIENT_OPACITY_STRONG} 0%,
      ${props.brandColor}${isBrightColor.value ? BRIGHT_GRADIENT_LIGHT : GRADIENT_OPACITY_LIGHT} 40%,
      transparent 80%),
    linear-gradient(${noisePattern.value.rotation}deg,
      ${props.brandColor}${isBrightColor.value ? BRIGHT_GRADIENT_MEDIUM : GRADIENT_OPACITY_MEDIUM} 0%,
      transparent 30%,
      ${props.brandColor}${isBrightColor.value ? BRIGHT_GRADIENT_ALT : DIM_GRADIENT_ALT} 70%,
      transparent 100%)
  `,
  textColor: WHITE_TEXT_COLOR,
  glowColor: props.brandColor,
}))

const textTransition = computed(() => ({
  transition: textParallaxStyle.value
    ? 'transform 100ms ease-out'
    : `transform ${ANIMATION_DURATION}ms ${ANIMATION_EASING}`,
}))

function handleMouseMove(event) {
  // only tilt on desktop
  if (window.innerWidth <= MOBILE_BREAKPOINT)
    return

  const card = event.currentTarget
  if (!card)
    return

  const rect = card.getBoundingClientRect()
  const centerX = rect.left + rect.width / 2
  const centerY = rect.top + rect.height / 2

  const mouseX = event.clientX
  const mouseY = event.clientY

  // delay tilt to prevent mouse-over insta-jumping and messing with the card
  if (tiltEnabled.value) {
    // clamp rotation values
    const rotateX = Math.max(
      -TILT_CLAMP,
      Math.min(
        TILT_CLAMP,
        ((mouseY - centerY) / rect.height) * -TILT_INTENSITY,
      ),
    )
    const rotateY = Math.max(
      -TILT_CLAMP,
      Math.min(TILT_CLAMP, ((mouseX - centerX) / rect.width) * TILT_INTENSITY),
    )

    // do the 3d tilt thing
    tiltStyle.value = `perspective(${PERSPECTIVE}px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(${CARD_SCALE}) translateZ(0)`

    // make text move with mouse
    const parallaxX = ((mouseX - centerX) / rect.width) * PARALLAX_SPEED
    const parallaxY = ((mouseY - centerY) / rect.height) * PARALLAX_SPEED
    textParallaxStyle.value = `translate3d(${parallaxX}px, ${parallaxY}px, 30px)`
  }

  // lighting follows mouse
  const lightX = ((mouseX - rect.left) / rect.width) * 100
  const lightY = ((mouseY - rect.top) / rect.height) * 100
  lightingStyle.value = `
    radial-gradient(circle at ${lightX}% ${lightY}%,
      ${props.brandColor}${LIGHTING_OPACITY_STRONG} 0%,
      ${props.brandColor}${LIGHTING_OPACITY_MEDIUM} 25%,
      transparent 70%)
  `
}

function handleMouseEnter() {
  isHovered.value = true
  emit('hover')

  // wait a bit before enabling tilt !!
  tiltTimeout.value = setTimeout(() => {
    tiltEnabled.value = true
  }, TILT_DELAY)
}

function handleMouseLeave() {
  isHovered.value = false
  tiltEnabled.value = false
  tiltStyle.value = ''
  textParallaxStyle.value = ''
  lightingStyle.value = ''
  emit('unhover')

  // cleanup timeout stuff
  if (tiltTimeout.value) {
    clearTimeout(tiltTimeout.value)
    tiltTimeout.value = null
  }
}
</script>

<template>
  <a
    :href="href"
    target="_blank"
    :style="{
      'transform': tiltStyle,
      'backgroundColor': isHovered
        ? isBrightColor.value
          ? props.brandColor
          : DARK_BG_COLOR
        : BLACK_BG_COLOR,
      'borderColor': isHovered ? props.brandColor : 'transparent',
      'boxShadow': isHovered
        ? `4px 4px 0 0 ${props.brandColor}, 2px 2px 10px 5px rgba(0 0 0 / 1)`
        : 'none',
      'transition': `transform ${tiltEnabled ? '150ms' : '400ms'} ease-out, background-color ${ANIMATION_DURATION}ms ${ANIMATION_EASING}, border-color ${ANIMATION_DURATION}ms ${ANIMATION_EASING}, box-shadow ${ANIMATION_DURATION}ms ${ANIMATION_EASING}`,
      '--brand-color': props.brandColor,
      '--brand-glow': dynamicStyles.glowColor,
    }"
    class="
      group relative flex h-[140px] w-[198px] origin-center flex-col
      overflow-hidden border-2 p-4
      [transform-style:preserve-3d]
      hover:relative hover:z-10 hover:cursor-alias
    "
    @mouseenter="handleMouseEnter"
    @mousemove="handleMouseMove"
    @mouseleave="handleMouseLeave"
  >
    <!-- fancy background gradients -->
    <div
      class="
        pointer-events-none absolute inset-0 opacity-0 transition-opacity
        duration-[600ms] ease-out
        group-hover:opacity-100
      "
      :style="{ background: dynamicStyles.gradientBackground }"
    />
    <!-- color burn effect layer -->
    <div
      class="
        pointer-events-none absolute inset-0 opacity-0 mix-blend-color-burn
        transition-opacity duration-[600ms] ease-out
      "
      :class="
        isBrightColor ? 'group-hover:opacity-90' : `group-hover:opacity-70`
      "
      :style="{ background: props.brandColor }"
    />
    <!-- mouse lighting effect -->
    <div
      v-if="lightingStyle"
      class="
        pointer-events-none absolute inset-0 opacity-40 mix-blend-screen
        transition-opacity duration-300 ease-out
      "
      :style="{ background: lightingStyle }"
    />
    <div
      class="mb-6 flex items-center gap-4"
      :style="{
        ...textTransition,
        transform: textParallaxStyle,
      }"
    >
      <!-- the actual title -->
      <span
        :style="{
          filter: isHovered
            ? `contrast(${HOVER_CONTRAST}) saturate(${HOVER_SATURATION}) brightness(${HOVER_BRIGHTNESS})`
            : `contrast(${DEFAULT_CONTRAST})`,
          transition: `all ${ANIMATION_DURATION}ms ${ANIMATION_EASING}`,
          textShadow:
            isHovered && isBrightColor
              ? `${TEXT_SHADOW_OFFSET} ${TEXT_SHADOW_BLUR} ${TEXT_SHADOW_BLUR} ${TEXT_SHADOW_COLOR}`
              : 'none',
        }"
        class="
          relative z-20 translate-z-0 text-lg leading-none font-semibold
          text-gray-500
          [backface-visibility:hidden]
          group-hover:text-white
        "
        :class="{ '!text-white': props.isActive }"
      >
        {{ title }}
      </span>
    </div>
    <div
      class="relative mt-auto flex flex-col justify-end"
      :style="{
        ...textTransition,
        transform: textParallaxStyle,
      }"
    >
      <p
        :style="{
          filter: isHovered
            ? `drop-shadow(0 0 ${TEXT_GLOW_SECONDARY}px ${dynamicStyles.glowColor})`
            : 'none',
          transition: `all ${ANIMATION_DURATION}ms ${ANIMATION_EASING}`,
          textShadow:
            isHovered && isBrightColor
              ? `${TEXT_SHADOW_OFFSET} ${TEXT_SHADOW_BLUR} ${TEXT_SHADOW_BLUR} ${TEXT_SHADOW_COLOR}`
              : 'none',
        }"
        class="
          relative z-15 origin-bottom-left translate-z-0
          [background-clip:text]
          text-sm text-gray-700 mix-blend-normal
          [-webkit-background-clip:text]
          [backface-visibility:hidden]
          group-hover:-translate-y-6 group-hover:text-white
          group-hover:brightness-130
        "
        :class="{
          '!-translate-y-6 !text-white !brightness-130': props.isActive,
        }"
      >
        {{ role }}
      </p>
      <span
        :style="{
          color: isHovered ? props.brandColor : GRAY_TEXT_COLOR,
          filter: isHovered
            ? `drop-shadow(0 0 ${TEXT_GLOW_SECONDARY}px ${dynamicStyles.glowColor})`
            : 'none',
          transition: `all ${ANIMATION_DURATION}ms ${ANIMATION_EASING}`,
        }"
        class="
          absolute bottom-0 left-0 z-15 translate-y-6 translate-z-0 font-mono
          text-xs text-gray-300 opacity-0 transition-all
          [backface-visibility:hidden]
          group-hover:translate-y-0 group-hover:opacity-100
        "
        :class="{ '!translate-y-0 !opacity-100': props.isActive }"
      >
        {{ period }}
      </span>
    </div>
  </a>
</template>
