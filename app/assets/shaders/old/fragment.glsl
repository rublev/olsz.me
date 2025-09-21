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
    * COLOR MIXING LAYERS
    * We build up the final color in layers, like painting:
    * 1. Start with background
    * 2. Mix in first color using noise
    * 3. Mix in second color using different noise
    * 4. Blend based on vertex distortion
    * 5. Apply border fade
    */
    
    // Layer 1: Start with the base background color
    vec3 color = bg;
    
    // Layer 2: Blend in first color using noise pattern
    // noise1 * 0.6 means the noise influence is moderate (60% max)
    color = mix(color, c1, noise1 * 0.6);
    
    // Layer 3: Blend in second color using different noise pattern
    // noise2 * 0.4 means this noise has less influence (40% max)
    color = mix(color, c2, noise2 * 0.4);
    
    // Layer 4: Pure amorphous blending - no position-based gradients
    // Use only noise and distortion for completely organic color flow
    float organicBlend = (noise1 + noise2) * 0.5 + vDistortion * 0.3;
    organicBlend = smoothstep(-0.8, 0.8, organicBlend); // Smooth the blend values
    color = mix(color, mix(c1, c2, organicBlend), 0.4); // Pure noise-based color mixing
    
    /*
    * NO BORDER FADE - PURE GRADIENT
    * Completely removed border effects for uninterrupted gradient flow
    */
    // No border fade applied - pure, continuous gradient
    
    // Output the final color with full opacity (alpha = 1.0)
    gl_FragColor=vec4(color,1.);
}
