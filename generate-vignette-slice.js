// Generate a horizontal slice of the pixelated vignette (one row)
const pixelSize = 8
const outerEdgePixels = 5
const fadeWidthPixels = 150
const intensity = 0.075

// We need 155px total (5px solid edge + 150px fade)
const sliceWidth = outerEdgePixels + fadeWidthPixels // 155px
const sliceHeight = pixelSize // 8px (one pixel row)

let svgContent = `<svg viewBox="0 0 ${sliceWidth} ${sliceHeight}" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none">\n`

// Generate each 8px block across the width
const numBlocks = Math.ceil(sliceWidth / pixelSize)

for (let i = 0; i < numBlocks; i++) {
  const x = i * pixelSize
  const centerX = x + pixelSize / 2

  // Distance from left edge
  const edgeDistPixels = centerX

  let alpha = 0

  if (edgeDistPixels < outerEdgePixels) {
    // Very thin outer edge - solid
    alpha = 1
  } else if (edgeDistPixels < outerEdgePixels + fadeWidthPixels) {
    // Fade zone
    const t = (edgeDistPixels - outerEdgePixels) / fadeWidthPixels

    if (t < 0.3) {
      // Still mostly solid
      const fadeProgress = t / 0.3
      alpha = 1 - (1 - intensity) * fadeProgress
    } else {
      // Fading to transparent
      const fadeOut = (t - 0.3) / 0.7
      alpha = intensity * (1 - fadeOut)
    }
  }

  if (alpha > 0.001) {
    svgContent += `  <rect x="${x}" y="0" width="${pixelSize}" height="${sliceHeight}" fill="#000000" opacity="${alpha.toFixed(4)}"/>\n`
  }
}

svgContent += `</svg>`

console.log(svgContent)
