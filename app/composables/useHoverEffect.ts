import { reactive, ref } from 'vue'

// Type definitions
export interface HoverEffects {
  [property: string]: string | number
}

export interface HoverConfig {
  backgroundColor?: string
  effects?: {
    [elementKey: string]: HoverEffects
  }
}

// Global hover state
const currentHoverConfig = ref<HoverConfig | null>(null)
const hoverElements = reactive<{ [key: string]: HoverEffects }>({})

/**
 * Composable for managing flexible hover effects Allows configuration of
 * multiple element effects when hovering over components
 *
 * SETUP INSTRUCTIONS:
 *
 * 1. In your layout file (e.g., layouts/default.vue):
 *    - Import and initialize the composable
 *    - Provide the functions to child components
 *    - Apply dynamic background color based on hover config
 *
 *    Example:
 *    ```vue
 *    <script setup lang="ts">
 *    import { provide } from 'vue'
 *    import { useHoverEffects } from '~/composables/useHoverEffect'
 *
 *    const { currentHoverConfig, setHoverEffects, clearHoverEffects,
 *    getElementStyle, hasElementEffects } = useHoverEffects()
 *
 *    provide('hoverConfig', currentHoverConfig)
 *    provide('setHoverEffects', setHoverEffects)
 *    provide('clearHoverEffects', clearHoverEffects)
 *    provide('getElementStyle', getElementStyle)
 *    provide('hasElementEffects', hasElementEffects)
 *    </script>
 *
 *    <template>
 *      <div :style="{ backgroundColor:
 *      currentHoverConfig?.backgroundColor || 'black' }">
 *        <slot />
 *      </div>
 *    </template>
 *    ```
 *
 * 2. In pages that use hover effects (e.g., pages/index.vue):
 *    - Inject the required functions
 *    - Apply getElementStyle to elements you want to be affected
 *    - Add mouseleave handler to clear effects
 *
 *    Example:
 *    ```vue
 *      <script setup lang="ts">
 *      import { inject } from 'vue'
 *      import type { HoverConfig, HoverEffects } from '~/composables/useHoverEffect'
 *
 *      const setHoverEffects = inject<(config: HoverConfig) => void>('setHoverEffects')
 *      const clearHoverEffects = inject<() => void>('clearHoverEffects')
 *      const getElementStyle = inject<(elementKey: string) => Record<string, string | number>>('getElementStyle')
 *      </script>
 *
 *      <template>
 *        <div @mouseleave="clearHoverEffects">
 *          <h1 :style="getElementStyle('main-title')">Title</h1>
 *          <p :style="getElementStyle('description-text')">Description</p>
 *
 *          <HoverableComponent
 *            :hover-config="{
 *              backgroundColor: 'rgb(37, 99, 235)',
 *              effects: {
 *                'main-title': { color: '#dbeafe' },
 *                'description-text': { color: '#60a5fa', opacity: '0.9' }
 *              }
 *            }"
 *            @hover-enter="setHoverEffects"
 *          />
 *        </div>
 *      </template>
 *    ```
 *
 * 3. In hoverable components (e.g., ProjectCard.vue):
 *    - Accept hoverConfig prop
 *    - Emit hover-enter event on mouseenter
 *
 *    Example:
 *    ```vue
 *      <script setup lang="ts">
 *      interface Props {
 *        hoverConfig: HoverConfig
 *      }
 *      defineProps<Props>()
 *      defineEmits<{
 *        'hover-enter': [config: HoverConfig]
 *      }>()
 *      </script>
 *
 *      <template>
 *        <div @mouseenter="$emit('hover-enter', hoverConfig)">
 *          <!-- component content -->
 *        </div>
 *      </template>
 *    ```
 */
export function useHoverEffects() {
  /**
   * Set hover effects based on configuration
   */
  const setHoverEffects = (config: HoverConfig) => {
    currentHoverConfig.value = config

    // Apply effects to elements
    if (config?.effects) {
      Object.entries(config.effects).forEach(([elementKey, effects]) => {
        hoverElements[elementKey] = effects
      })
    }
  }

  /**
   * Clear all hover effects
   */
  const clearHoverEffects = () => {
    currentHoverConfig.value = null
    // Clear all element effects
    Object.keys(hoverElements).forEach((key) => {
      delete hoverElements[key]
    })
  }

  /**
   * Get computed style for a specific element
   */
  const getElementStyle = (
    elementKey: string,
  ): Record<string, string | number> => {
    const effects = hoverElements[elementKey]
    if (!effects)
      return {}

    // Convert effects object to CSS-in-JS style object
    const style: Record<string, string | number> = {}
    Object.entries(effects).forEach(([property, value]) => {
      // Handle CSS property name conversion (camelCase to kebab-case)
      style[property] = value
    })

    return style
  }

  /**
   * Check if an element has active hover effects
   */
  const hasElementEffects = (elementKey: string): boolean => {
    return elementKey in hoverElements && !!hoverElements[elementKey]
  }

  return {
    currentHoverConfig,
    hoverElements,
    setHoverEffects,
    clearHoverEffects,
    getElementStyle,
    hasElementEffects,
  }
}
