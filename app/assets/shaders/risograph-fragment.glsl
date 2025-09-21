/*
* RISOGRAPH PRINT FRAGMENT SHADER
*
* This shader recreates the authentic risograph printing aesthetic with:
* - Radial gradients that fade from center outward
* - Color quantization for that classic print registration look
* - Enhanced color separation effects
* - Organic, flowing color transitions
*/

// Helper function: Convert RGB values from 0-255 range to 0-1 range
vec3 rgb(float r, float g, float b) {
    return vec3(r / 255.0, g / 255.0, b / 255.0);
}

// Helper function: Convert single grayscale value from 0-255 to RGB
vec3 rgb(float c) {
    return vec3(c / 255.0, c / 255.0, c / 255.0);
}

// Inputs from JavaScript - the color palette for our risograph print
uniform vec3 u_bg; // Background color
uniform vec3 u_bgMain; // Main background color
uniform vec3 u_color1; // First ink color
uniform vec3 u_color2; // Second ink color
uniform float u_time; // Animation time for moving patterns

// Inputs from vertex shader
varying vec2 vUv; // UV coordinates (position on surface from 0,0 to 1,1)
varying float vDistortion; // How much the vertex was distorted

/*
* COLOR QUANTIZATION FUNCTION
* Reduces color precision to mimic risograph print limitations
*/
vec3 quantizeColor(vec3 color, float levels) {
    return floor(color * levels) / levels;
}

/*
* RADIAL FADE FUNCTION
* Creates circular gradients from center outward for authentic risograph look
*/
float radialFade(vec2 uv, vec2 center, float radius, float softness) {
    float dist = distance(uv, center);
    return 1.0 - smoothstep(radius - softness, radius + softness, dist);
}

void main() {
    /*
    * COLOR PREPARATION
    * Convert our color inputs to the proper GPU format
    */
    vec3 bg = rgb(u_bg.r, u_bg.g, u_bg.b); // Base background
    vec3 c1 = rgb(u_color1.r, u_color1.g, u_color1.b); // First ink color
    vec3 c2 = rgb(u_color2.r, u_color2.g, u_color2.b); // Second ink color
    vec3 bgMain = rgb(u_bgMain.r, u_bgMain.g, u_bgMain.b); // Paper background
    
    /*
    * ANIMATED NOISE PATTERNS
    * Create organic, flowing patterns like risograph ink bleeding
    */
    // First noise layer: broad, flowing patterns
    float noise1 = snoise(vUv * 2.0 + u_time * 0.08);
    
    // Second noise layer: finer details with different frequency
    float noise2 = snoise(vUv * 4.0 + u_time * 0.12);
    
    // Third noise layer: very fine texture for print grain
    float noise3 = snoise(vUv * 8.0 + u_time * 0.05);
    
    /*
    * RISOGRAPH LAYER BUILDING
    * Build up colors like separate ink layers in risograph printing
    */
    
    // Start with paper background
    vec3 color = bg;
    
    /*
    * FIRST INK LAYER (Primary color)
    * Use radial fade with noise modulation for organic shape
    */
    vec2 center1 = vec2(0.3 + sin(u_time * 0.1) * 0.2, 0.5 + cos(u_time * 0.15) * 0.1);
    float radius1 = 0.6 + noise1 * 0.3;
    float fade1 = radialFade(vUv, center1, radius1, 0.4);
    
    // Apply first ink with noise modulation
    float ink1Strength = fade1 * (0.7 + noise2 * 0.3) * (0.8 + noise3 * 0.2);
    color = mix(color, c1, ink1Strength * 0.8);
    
    /*
    * SECOND INK LAYER (Secondary color)
    * Offset center for color separation effect
    */
    vec2 center2 = vec2(0.7 + cos(u_time * 0.12) * 0.2, 0.4 + sin(u_time * 0.18) * 0.15);
    float radius2 = 0.5 + noise2 * 0.25;
    float fade2 = radialFade(vUv, center2, radius2, 0.3);
    
    // Apply second ink with different noise pattern
    float ink2Strength = fade2 * (0.6 + noise1 * 0.4) * (0.9 + noise3 * 0.1);
    color = mix(color, c2, ink2Strength * 0.7);
    
    /*
    * SOFT VERTEX DISTORTION INFLUENCE
    * Use vertex distortion to create flowing color interactions without hard lines
    */
    // Create a much softer dynamic gradient to eliminate hard transitions
    float softDistortionInfluence = smoothstep(-0.3, 0.3, vDistortion);
    vec3 distortionColor = mix(c1, c2, smoothstep(0.3, 0.7, vUv.x + vDistortion * 0.2));
    color = mix(color, distortionColor, softDistortionInfluence * 0.25);
    
    /*
    * RISOGRAPH COLOR QUANTIZATION
    * Reduce color precision for authentic print look
    */
    color = quantizeColor(color, 16.0); // 16 levels per channel for slight banding
    
    /*
    * PRINT REGISTRATION EFFECTS
    * Subtle offset and color separation for authentic risograph misalignment
    */
    vec2 offset = vec2(sin(u_time * 0.1) * 0.002, cos(u_time * 0.15) * 0.001);
    
    // Sample colors with slight offset for registration effect
    vec3 offsetColor = color;
    // Slight color shift for that classic misregistration look
    offsetColor.r *= 1.0 + offset.x * 10.0;
    offsetColor.g *= 1.0 + offset.y * 8.0;
    
    // Blend with offset version very subtly
    color = mix(color, offsetColor, 0.1);
    
    /*
    * PAPER TEXTURE AND EDGE FADE
    * Soft vignette effect like ink absorption at paper edges
    */
    float paperFade=radialFade(vUv,vec2(.5,.5),1.2,.8);
    color=mix(bgMain,color,paperFade);
    
    // Output the final risograph color
    gl_FragColor=vec4(color,1.);
}
