// Generate a 9-patch border image for the pixelated vignette
const pixelSize = 8
const outerEdgePixels = 5
const fadeWidthPixels = 150
const intensity = 0.075

// 9-patch structure:
// [corner 155×155] [edge] [corner 155×155]
// [edge          ] [center] [edge          ]
// [corner 155×155] [edge] [corner 155×155]

const edgeSize = outerEdgePixels + fadeWidthPixels // 155px
const centerSize = pixelSize // 8px (one pixel block)
const totalSize = edgeSize + centerSize + edgeSize // 318px

const width = totalSize
const height = totalSize

let svgContent = `<svg viewBox="0 0 ${width} ${height}" xmlns="http://www.w3.org/2000/svg">\n`

// Generate each 8×8 pixel block
const cols = Math.ceil(width / pixelSize)
const rows = Math.ceil(height / pixelSize)

for (let row = 0; row < rows; row++) {
  for (let col = 0; col < cols; col++) {
    const x = col * pixelSize
    const y = row * pixelSize

    // Calculate center of pixel block
    const centerX = x + pixelSize / 2
    const centerY = y + pixelSize / 2

    // Calculate pixel distance from all edges
    const distXPixels = Math.min(centerX, width - centerX)
    const distYPixels = Math.min(centerY, height - centerY)
    const edgeDistPixels = Math.min(distXPixels, distYPixels)

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

    // Only add rect if it has visible opacity
    if (alpha > 0.001) {
      svgContent += `  <rect x="${x}" y="${y}" width="${pixelSize}" height="${pixelSize}" fill="#000000" opacity="${alpha.toFixed(4)}"/>\n`
    }
  }
}

svgContent += `</svg>`

console.log(svgContent)
