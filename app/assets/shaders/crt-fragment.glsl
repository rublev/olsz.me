/*
* CRT MONITOR FRAGMENT SHADER
*
* This shader recreates the authentic CRT monitor experience with:
* - Phosphor glow and color bleeding
* - Subtle scanline effects
* - Gamma correction for CRT color response
* - Screen curvature vignette
* - Color separation and chromatic aberration
*/

// Helper function: Convert RGB values from 0-255 range to 0-1 range
vec3 rgb(float r, float g, float b) {
    return vec3(r / 255.0, g / 255.0, b / 255.0);
}

// Helper function: Convert single grayscale value from 0-255 to RGB
vec3 rgb(float c) {
    return vec3(c / 255.0, c / 255.0, c / 255.0);
}

// Inputs from JavaScript - the color palette for our CRT monitor
uniform vec3 u_bg; // Background color
uniform vec3 u_bgMain; // Main background color
uniform vec3 u_color1; // First phosphor color
uniform vec3 u_color2; // Second phosphor color
uniform float u_time; // Animation time for monitor effects

// Inputs from vertex shader
varying vec2 vUv; // UV coordinates (position on surface from 0,0 to 1,1)
varying float vDistortion; // How much the vertex was distorted

/*
* CRT GAMMA CORRECTION
* Apply authentic CRT gamma curve for realistic color response
*/
vec3 crtGamma(vec3 color) {
    return pow(color, vec3(2.2)); // CRT gamma correction
}

/*
* PHOSPHOR GLOW EFFECT
* Simulate the way CRT phosphors glow and bleed light
*/
vec3 phosphorGlow(vec3 color, float intensity) {
    // Enhance bright areas with soft glow
    vec3 bright = max(color - 0.7, 0.0) * 3.0;
    return color + bright * intensity;
}

/*
* SCANLINE EFFECT
* Create subtle horizontal lines like CRT scan beams
*/
float scanlines(vec2 uv, float intensity) {
    float scanline = sin(uv.y * 800.0) * 0.5 + 0.5;
    return 1.0 - (1.0 - scanline) * intensity;
}

/*
* SCREEN CURVATURE VIGNETTE
* Simulate the curved glass of CRT monitors
*/
float screenCurvature(vec2 uv) {
    // Create radial falloff from center
    vec2 center = uv - 0.5;
    float dist = length(center);
    
    // Smooth vignette that gets darker toward edges
    return 1.0 - smoothstep(0.3, 0.8, dist);
}

/*
* CHROMATIC ABERRATION
* Color separation effect from CRT electron guns
*/
vec3 chromaticAberration(vec3 color, vec2 uv, float amount) {
    vec2 offset = (uv - 0.5) * amount;
    
    // Shift red and blue channels slightly
    color.r *= 1.0 + offset.x * 0.5;
    color.b *= 1.0 - offset.x * 0.3;
    
    return color;
}

void main() {
    /*
    * COLOR PREPARATION
    * Convert our color inputs to the proper GPU format
    */
    vec3 bg = rgb(u_bg.r, u_bg.g, u_bg.b); // Base background
    vec3 c1 = rgb(u_color1.r, u_color1.g, u_color1.b); // First phosphor color
    vec3 c2 = rgb(u_color2.r, u_color2.g, u_color2.b); // Second phosphor color
    vec3 bgMain = rgb(u_bgMain.r, u_bgMain.g, u_bgMain.b); // Screen background
    
    /*
    * ANIMATED NOISE PATTERNS
    * Create flowing patterns with CRT-like flicker
    */
    // First noise: broad phosphor patterns with slight flicker
    float noise1 = snoise(vUv * 1.5 + u_time * 0.06);
    
    // Second noise: finer patterns for phosphor detail
    float noise2 = snoise(vUv * 3.0 + u_time * 0.08);
    
    // Screen flicker noise: very subtle random variation
    float flicker = snoise(vec2(u_time * 2.0, 0.0)) * 0.02 + 0.98;
    
    /*
    * CRT PHOSPHOR LAYER BUILDING
    * Build up colors like overlapping phosphor dots
    */
    
    // Start with screen background
    vec3 color = bg;
    
    /*
    * RED PHOSPHOR LAYER
    * Simulate red phosphor dots with soft glow
    */
    float redPhosphor = noise1 * 0.6 + 0.4;
    redPhosphor *= 0.8 + noise2 * 0.2;
    vec3 redGlow = c1 * redPhosphor;
    color = mix(color, redGlow, redPhosphor * 0.7);
    
    /*
    * GREEN/BLUE PHOSPHOR LAYER
    * Secondary phosphor with different pattern
    */
    float bluePhosphor = noise2 * 0.5 + 0.3;
    bluePhosphor *= 0.9 + noise1 * 0.1;
    vec3 blueGlow = c2 * bluePhosphor;
    color = mix(color, blueGlow, bluePhosphor * 0.6);
    
    /*
    * SOFT VERTEX DISTORTION INFLUENCE
    * Use mesh distortion to create flowing phosphor interactions without hard lines
    */
    float softPhosphorDistortion = smoothstep(-0.4, 0.4, vDistortion);
    vec3 distortionColor = mix(c1, c2, smoothstep(0.4, 0.6, 0.5 + vDistortion * 0.15));
    color = mix(color, distortionColor, softPhosphorDistortion * 0.2);
    
    /*
    * CRT EFFECTS APPLICATION
    */
    
    // Apply gamma correction for authentic CRT look
    color = crtGamma(color);
    
    // Add phosphor glow effect
    color = phosphorGlow(color, 0.3);
    
    // Apply subtle scanlines
    float scanlineEffect = scanlines(vUv, 0.08);
    color *= scanlineEffect;
    
    // Add chromatic aberration
    color = chromaticAberration(color, vUv, 0.02);
    
    // Apply screen curvature vignette
    float curvature = screenCurvature(vUv);
    color *= curvature;
    
    // Apply screen flicker
    color *= flicker;
    
    /*
    * SCREEN BEZEL EFFECT
    * Soft fade to black at edges like CRT monitor bezels
    */
    vec2 edge = abs(vUv - 0.5) * 2.0;
    float bezel = smoothstep(0.85, 1.0, max(edge.x, edge.y));
    color = mix(color, vec3(0.0), bezel);
    
    /*
    * FINAL COLOR ENHANCEMENT
    * Boost saturation and contrast for that classic CRT pop
    */
    // Increase saturation slightly
    float luminance=dot(color,vec3(.299,.587,.114));
    color=mix(vec3(luminance),color,1.15);
    
    // Subtle contrast boost
    color=(color-.5)*1.1+.5;
    
    // Output the final CRT color
    gl_FragColor=vec4(color,1.);
}
