// Generate pixelated vignette SVG with actual rectangular blocks
const width = 1920
const height = 1280
const pixelSize = 8
const outerEdgePixels = 5
const fadeWidthPixels = 150
const intensity = 0.075

const cols = Math.ceil(width / pixelSize)
const rows = Math.ceil(height / pixelSize)

let svgContent = `<svg viewBox="0 0 ${width} ${height}" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid slice">\n`

// Generate each pixel block
for (let row = 0; row < rows; row++) {
  for (let col = 0; col < cols; col++) {
    const x = col * pixelSize
    const y = row * pixelSize

    // Calculate center of pixel block
    const centerX = x + pixelSize / 2
    const centerY = y + pixelSize / 2

    // Calculate pixel distance from edges
    const distXPixels = Math.min(centerX, width - centerX)
    const distYPixels = Math.min(centerY, height - centerY)
    const edgeDistPixels = Math.min(distXPixels, distYPixels)

    let alpha = 0

    if (edgeDistPixels < outerEdgePixels) {
      // Very thin outer edge - solid color
      alpha = 1
    } else if (edgeDistPixels < outerEdgePixels + fadeWidthPixels) {
      // Middle ring - fade out
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
    } else {
      // Center - transparent
      alpha = 0
    }

    // Only add rect if it has visible opacity
    if (alpha > 0.001) {
      svgContent += `  <rect x="${x}" y="${y}" width="${pixelSize}" height="${pixelSize}" fill="#000000" opacity="${alpha.toFixed(4)}"/>\n`
    }
  }
}

svgContent += `</svg>`

console.log(svgContent)
