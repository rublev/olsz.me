import { computed, onMounted, ref } from 'vue'

export function useResponsivePixelSize() {
  const windowWidth = ref(0)

  // Responsive pixel size
  const pixelSize = computed(() => {
    if (windowWidth.value >= 1280)
      return 7
    if (windowWidth.value >= 768)
      return 6
    if (windowWidth.value >= 640)
      return 5
    return 4
  })

  // Debug colors
  const debugColor = computed(() => {
    if (windowWidth.value >= 1280)
      return '#ff00ff'
    if (windowWidth.value >= 768)
      return '#0000ff'
    if (windowWidth.value >= 640)
      return '#ff0000'
    return '#00ff00'
  })

  onMounted(() => {
    windowWidth.value = window.innerWidth
    window.addEventListener('resize', () => {
      windowWidth.value = window.innerWidth
    })
  })

  return {
    windowWidth,
    pixelSize,
    debugColor,
  }
}
