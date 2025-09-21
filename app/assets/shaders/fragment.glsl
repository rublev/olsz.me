/*
* GRADIENT MESH FRAGMENT SHADER
*
* This shader creates colorful, animated gradients by mixing multiple colors
* using noise patterns and the vertex distortion from the vertex shader.
* Think of it like painting with multiple brushes that blend together organically.
*/

// Helper function: Convert RGB values from 0-255 range to 0-1 range
// GPU colors work with decimal values between 0 and 1, not 0-255
vec3 rgb(float r, float g, float b) {
    return vec3(r / 255.0, g / 255.0, b / 255.0);
}

// Helper function: Convert single grayscale value from 0-255 to RGB
// Creates gray colors where all RGB channels have the same value
vec3 rgb(float c) {
    return vec3(c / 255.0, c / 255.0, c / 255.0);
}

// Inputs from JavaScript - the color palette for our gradient
uniform vec3 u_bg; // Background color (base layer)
uniform vec3 u_bgMain; // Main background color (used for borders)
uniform vec3 u_color1; // First gradient color
uniform vec3 u_color2; // Second gradient color
uniform float u_time; // Animation time for moving patterns

// Inputs from vertex shader - interpolated values across the surface
varying vec2 vUv; // UV coordinates (position on surface from 0,0 to 1,1)
varying float vDistortion; // How much the vertex was distorted (from vertex shader)

void main() {
    /*
    * COLOR PREPARATION
    * Convert our color inputs to the proper GPU format
    */
    vec3 bg = rgb(u_bg.r, u_bg.g, u_bg.b); // Base background
    vec3 c1 = rgb(u_color1.r, u_color1.g, u_color1.b); // First gradient color
    vec3 c2 = rgb(u_color2.r, u_color2.g, u_color2.b); // Second gradient color
    vec3 bgMain = rgb(u_bgMain.r, u_bgMain.g, u_bgMain.b); // Border background
    
    /*
    * COMPLETELY AMORPHOUS NOISE PATTERNS
    * Use offset and rotated UV coordinates to eliminate any directional patterns
    */
    // First noise: use rotated and offset coordinates to break spatial patterns
    vec2 offset1 = vUv + vec2(sin(u_time * 0.08) * 0.5, cos(u_time * 0.08) * 0.5);
    float noise1 = snoise(offset1 * 3.0 + u_time * 0.08);
    
    // Second noise: different rotation and scale to avoid alignment
    vec2 offset2 = vUv.yx * 2.5 + vec2(cos(u_time * 0.12) * 0.3, sin(u_time * 0.09) * 0.4);
    float noise2 = snoise(offset2 + u_time * 0.1);
    
    /*
    * FOUR-COLOR LAYERED MIXING SYSTEM
    * Build up colors in safe, clamped layers like the original working approach
    * but incorporate all 4 colors through careful layering
    */
    
    // Generate additional noise patterns for the extra colors
    vec2 offset3 = vUv * 2.2 + vec2(sin(u_time * 0.06) * 0.3, cos(u_time * 0.05) * 0.4);
    float noise3 = snoise(offset3 + u_time * 0.07);
    
    // Layer 1: Start with the base background color
    vec3 color = bg;
    
    // Layer 2: Blend in first color using clamped noise pattern
    float clampedNoise1 = clamp(noise1, -0.5, 0.5) + 0.5; // Convert to 0-1 range
    color = mix(color, c1, clampedNoise1 * 0.5);
    
    // Layer 3: Blend in second color using different clamped noise
    float clampedNoise2 = clamp(noise2, -0.4, 0.4) + 0.5; // Convert to 0-1 range
    color = mix(color, c2, clampedNoise2 * 0.4);
    
    // Layer 4: Blend in bgMain (4th color) using third noise pattern
    float clampedNoise3 = clamp(noise3, -0.3, 0.3) + 0.5; // Convert to 0-1 range
    color = mix(color, bgMain, clampedNoise3 * 0.3);
    
    // Layer 5: Final organic blending using distortion
    float organicBlend = clamp((noise1 + noise2) * 0.3 + vDistortion * 0.2, -0.6, 0.6);
    organicBlend = (organicBlend + 0.6) / 1.2; // Normalize to 0-1 range
    color = mix(color, mix(c1, c2, organicBlend), 0.2);
    
    // Final color clamping to prevent any black pixels
    color = clamp(color, vec3(0.0), vec3(1.0));
    
    /*
    * NO BORDER FADE - PURE GRADIENT
    * Completely removed border effects for uninterrupted gradient flow
    */
    // No border fade applied - pure, continuous gradient
    
    // Output the final color with full opacity (alpha = 1.0)
    gl_FragColor=vec4(color,1.);
    
}
