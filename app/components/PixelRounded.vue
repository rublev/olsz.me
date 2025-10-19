<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  /** Radius of the corner before scaling (like CSS border-radius) */
  radius?: number
  /** Pixel multiplier - 1 visual pixel will be this many on-screen pixels */
  multiplier?: number
  /** Width of the border before scaling */
  borderWidth?: number
  /** Color of the border */
  borderColor?: string
  /** Enable drop shadow */
  dropShadow?: boolean
  /** Drop shadow X offset in pixels */
  dropShadowX?: number
  /** Drop shadow Y offset in pixels */
  dropShadowY?: number
  /** Drop shadow color */
  dropShadowColor?: string
}

const props = withDefaults(defineProps<Props>(), {
  radius: 8,
  multiplier: 4,
  borderWidth: 0,
  borderColor: '#0099ff',
  dropShadow: false,
  dropShadowX: 5,
  dropShadowY: 5,
  dropShadowColor: '#000000',
})

const hasBorder = computed(() => props.borderWidth > 0)

// ============================================================================
// Coordinate generation functions (ported from main.js)
// ============================================================================

function generatePoints(radius: number, pixelSize: number, offset = 0) {
  const coords: Array<{ x: number, y: number }> = []

  const lastCoords = {
    x: -1,
    y: -1,
  }

  for (let i = 270; i > 225; i--) {
    const x
      = Math.floor(radius * Math.sin((2 * Math.PI * i) / 360) + radius + 0.5)
        * pixelSize
    const y
      = Math.floor(radius * Math.cos((2 * Math.PI * i) / 360) + radius + 0.5)
        * pixelSize

    if (x !== lastCoords.x || y !== lastCoords.y) {
      lastCoords.x = x
      lastCoords.y = y

      coords.push({
        x: x + offset * pixelSize,
        y: y + offset * pixelSize,
      })
    }
  }

  const mergedCoords = mergeCoords(coords)
  const corners = addCorners(mergedCoords)

  return corners
}

function mergeCoords(coords: Array<{ x: number, y: number }>) {
  return coords.reduce(
    (result, point, index) => {
      const nextPoint = coords[index + 1]
      const prevPoint = coords[index - 1]

      if (index !== coords.length - 1 && point.x === 0 && nextPoint?.x === 0) {
        return result
      }

      if (index !== 0 && point.y === 0 && prevPoint?.y === 0) {
        return result
      }

      if (
        index !== 0
        && index !== coords.length - 1
        && prevPoint
        && nextPoint
        && point.x === prevPoint.x
        && point.x === nextPoint.x
      ) {
        return result
      }

      result.push(point)
      return result
    },
    [] as Array<{ x: number, y: number }>,
  )
}

function addCorners(coords: Array<{ x: number, y: number }>) {
  return coords.reduce(
    (result, point, i) => {
      result.push(point)

      const nextPoint = coords[i + 1]
      if (
        coords.length > 1
        && i < coords.length - 1
        && nextPoint
        && nextPoint.x !== point.x
        && nextPoint.y !== point.y
      ) {
        result.push({
          x: nextPoint.x,
          y: point.y,
        })
      }

      return result
    },
    [] as Array<{ x: number, y: number }>,
  )
}

function flipCoords(coords: Array<{ x: number, y: number }>) {
  return [
    ...coords,
    ...coords.map(({ x, y }) => ({ x: y, y: x })).reverse(),
  ].filter(({ x, y }, i, arr) => {
    const prevPoint = arr[i - 1]
    return !i || !prevPoint || prevPoint.x !== x || prevPoint.y !== y
  })
}

function insetCoords(
  coords: Array<{ x: number, y: number }>,
  pixelSize: number,
  offset: number,
) {
  return coords
    .map(({ x, y }) => ({
      x: x + pixelSize * offset,
      y: y + pixelSize * Math.floor(offset / 2),
    }))
    .reduce(
      (ret, item) => {
        const lastItem = ret[ret.length - 1]
        if (ret.length > 0 && lastItem && lastItem.x === lastItem.y) {
          return ret
        }

        ret.push(item)

        return ret
      },
      [] as Array<{ x: number, y: number }>,
    )
}

function mirrorCoords(coords: Array<{ x: number, y: number }>, offset = 0) {
  const edgeCoord = (n: number) => {
    if (offset) {
      return n === 0
        ? `calc(100% - ${offset}px)`
        : `calc(100% - ${offset + n}px)`
    }

    return n === 0 ? '100%' : `calc(100% - ${n}px)`
  }

  return [
    ...coords.map(({ x, y }) => ({
      x: offset ? `${x + offset}px` : `${x}px`,
      y: offset ? `${y + offset}px` : `${y}px`,
    })),
    ...coords.map(({ x, y }) => ({
      x: edgeCoord(y),
      y: offset ? `${x + offset}px` : `${x}px`,
    })),
    ...coords.map(({ x, y }) => ({
      x: edgeCoord(x),
      y: edgeCoord(y),
    })),
    ...coords.map(({ x, y }) => ({
      x: offset ? `${y + offset}px` : `${y}px`,
      y: edgeCoord(x),
    })),
  ]
}

function generatePath(
  coords: Array<{ x: number, y: number }>,
  reverse = false,
) {
  const mirroredCoords = mirrorCoords(coords)

  return (reverse ? mirroredCoords : mirroredCoords.reverse())
    .map(point => `${point.x} ${point.y}`)
    .join(', ')
}

function generateOuterPath(radius: number, pixelSize: number) {
  const points = generatePoints(radius, pixelSize)
  const flipped = flipCoords(points)

  return generatePath(flipped)
}

function generateInnerPath(
  radius: number,
  pixelSize: number,
  offset: number,
  reverse = false,
) {
  const points = generatePoints(radius, pixelSize)
  const inset
    = offset < radius
      ? insetCoords(points, pixelSize, offset)
      : generatePoints(2, pixelSize, offset)
  const flipped = flipCoords(inset)
  const corners = addCorners(flipped)

  return generatePath(corners, reverse)
}

// ============================================================================
// Computed styles
// ============================================================================

const outerPath = computed(() => {
  return generateOuterPath(props.radius, props.multiplier)
})

const innerPath = computed(() => {
  if (!hasBorder.value)
    return ''
  return generateInnerPath(
    props.radius,
    props.multiplier,
    props.borderWidth,
    true,
  )
})

const borderPath = computed(() => {
  if (!hasBorder.value)
    return ''

  const outer = generateOuterPath(props.radius, props.multiplier)
  const inner = innerPath.value
  const halfPoint = `${props.borderWidth * props.multiplier}px 50%`

  return `${outer}, 0px 50%, ${halfPoint}, ${inner}, ${halfPoint}, 0px 50%`
})

const outerStyle = computed(() => {
  return {
    clipPath: `polygon(${outerPath.value})`,
  }
})

const wrapperStyle = computed(() => {
  if (!props.dropShadow)
    return {}

  return {
    filter: `drop-shadow(${props.dropShadowX}px ${props.dropShadowY}px 0px ${props.dropShadowColor})`,
  }
})

const innerStyle = computed(() => {
  if (!hasBorder.value)
    return {}

  return {
    clipPath: `polygon(${innerPath.value})`,
    border: `${props.borderWidth * props.multiplier}px solid transparent`,
  }
})

const borderStyle = computed(() => {
  if (!hasBorder.value)
    return {}

  return {
    clipPath: `polygon(${borderPath.value})`,
    background: props.borderColor,
  }
})
</script>

<template>
  <div v-if="dropShadow" :style="wrapperStyle">
    <div
      class="pixel-rounded"
      :class="{ 'pixel-rounded--wrapper': hasBorder }"
      :style="outerStyle"
    >
      <div v-if="hasBorder" class="pixel-rounded__inner" :style="innerStyle">
        <slot />
      </div>
      <slot v-else />
      <div
        v-if="hasBorder"
        class="pixel-rounded__border"
        :style="borderStyle"
      />
    </div>
  </div>
  <div
    v-else
    class="pixel-rounded"
    :class="{ 'pixel-rounded--wrapper': hasBorder }"
    :style="outerStyle"
  >
    <div v-if="hasBorder" class="pixel-rounded__inner" :style="innerStyle">
      <slot />
    </div>
    <slot v-else />
    <div v-if="hasBorder" class="pixel-rounded__border" :style="borderStyle" />
  </div>
</template>
