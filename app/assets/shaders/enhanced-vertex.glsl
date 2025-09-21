/*
 * ENHANCED ORGANIC VERTEX SHADER
 *
 * This vertex shader creates more complex, flowing organic movement with:
 * - Multiple layers of noise for rich, complex distortion
 * - Circular and radial movement patterns
 * - Time-based wave propagation
 * - Multiple frequency combinations for natural flow
 * - Enhanced amplitude control for dramatic effects
 */

// Inputs from JavaScript - these change over time or user interaction
uniform float u_time; // Current animation time (continuously increasing)
uniform vec2 u_randomisePosition; // Random offset values to make the movement more organic

// Outputs to fragment shader - these values get interpolated across the surface
varying float vDistortion; // How much this vertex was moved (used for color mixing)
varying vec2 vUv; // Texture coordinates (0,0 to 1,1 across the surface)

void main() {
    // Pass UV coordinates to fragment shader unchanged
    vUv = uv;

    /*
     * MULTI-LAYER ORGANIC DISTORTION
     * We use multiple noise calculations at different scales and frequencies
     * to create rich, complex organic movement that feels natural and flowing
     */

    /*
     * LAYER 1: Primary Wave System
     * Large-scale flowing waves that form the main movement structure
     */
    // Create flowing horizontal waves with time animation
    float primaryWave = snoise(vUv * 2.0 + vec2(u_time * 0.1, u_time * 0.08));

    // Add vertical wave component for more complex flow
    float verticalWave = snoise(vUv.yx * 1.8 + vec2(u_time * 0.12, u_time * 0.07));

    // Combine waves with different amplitudes
    float layer1 = primaryWave * 0.7 + verticalWave * 0.5;

    /*
     * LAYER 2: Secondary Detail Waves
     * Medium-scale waves that add detail and complexity to the main flow
     */
    // Diagonal wave patterns for more organic feel
    float diagonalWave1 = snoise((vUv + vUv.yx) * 3.0 + u_time * 0.15);
    float diagonalWave2 = snoise((vUv - vUv.yx * 0.5) * 2.5 + u_time * 0.09);

    // Combine diagonal patterns
    float layer2 = (diagonalWave1 * 0.4 + diagonalWave2 * 0.3) * 0.8;

    /*
     * LAYER 3: Fine Detail Texture
     * Small-scale noise for surface texture and fine movement
     */
    float fineDetail = snoise(vUv * 6.0 + u_time * 0.2) * 0.3;
    float microDetail = snoise(vUv * 12.0 + u_time * 0.05) * 0.15;

    float layer3 = fineDetail + microDetail;

    /*
     * LAYER 4: Radial Pulse System
     * Circular waves emanating from center points for organic breathing effects
     */
    vec2 center1 = vec2(0.3 + sin(u_time * 0.08) * 0.2, 0.6 + cos(u_time * 0.12) * 0.15);
    vec2 center2 = vec2(0.7 + cos(u_time * 0.1) * 0.18, 0.4 + sin(u_time * 0.14) * 0.12);

    float radialPulse1 = snoise(vec2(length(vUv - center1) * 8.0 - u_time * 0.3, 0.0)) * 0.4;
    float radialPulse2 = snoise(vec2(length(vUv - center2) * 6.0 - u_time * 0.25, 0.0)) * 0.3;

    float layer4 = radialPulse1 + radialPulse2;

    /*
     * COMBINE ALL LAYERS
     * Mix all the noise layers with different weights for rich, complex movement
     */
    vDistortion = layer1 + layer2 * 0.6 + layer3 * 0.4 + layer4 * 0.5;

    // Apply random position influence for extra organic variation
    vDistortion += snoise(vUv + u_randomisePosition * 0.1) * 0.2;

    /*
     * CALCULATE VERTEX DISPLACEMENT
     * Apply the combined distortion to vertex position in multiple axes
     */

    // Start with the original vertex position
    vec3 pos = position;

    /*
     * Z-AXIS DISTORTION (Depth/Height)
     * Primary wave movement - creates the main flowing surface
     */
    pos.z += vDistortion * 45.0; // Stronger amplitude for more dramatic waves

    /*
     * X-AXIS DISTORTION (Horizontal Flow)
     * Secondary wave movement for left/right flow
     */
    float xDistortion = snoise(vUv.yx * 2.5 + u_time * 0.11 - u_randomisePosition * 0.08);
    pos.x += xDistortion * 30.0;

    /*
     * Y-AXIS DISTORTION (Vertical Flow)
     * Tertiary wave movement for up/down flow
     */
    float yDistortion = snoise((vUv + vec2(0.5, 0.0)) * 2.2 + u_time * 0.13);
    pos.y += yDistortion * 20.0;

    /*
     * CIRCULAR MOTION COMPONENT
     * Add subtle circular/spiral movement for more organic flow
     */
    float angle = atan(vUv.y - 0.5, vUv.x - 0.5) + u_time * 0.1;
    float radius = length(vUv - 0.5);

    float circularMotion = snoise(vec2(angle * 2.0, radius * 4.0)) * 0.3;
    pos.x += cos(angle + circularMotion) * radius * 8.0;
    pos.y += sin(angle + circularMotion) * radius * 6.0;

    /*
     * FINAL VERTEX TRANSFORMATION
     * Transform the enhanced organic position to screen coordinates
     */
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}
