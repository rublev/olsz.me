/*
* PIXELATE EFFECT FRAGMENT SHADER
*
* This shader creates a retro "low pixel" effect by grouping pixels into larger blocks.
* Think of it like converting a high-res photo into LEGO blocks - each block shows
* one color instead of all the tiny details.
*/

// Input from vertex shader
varying vec2 vUv; // UV coordinates (0,0 to 1,1 across the surface)

// Inputs from JavaScript
uniform sampler2D tDiffuse; // The original image we want to pixelate
uniform vec2 u_resolution; // Screen width and height in pixels
uniform float intensity; // How much pixelation (0.0 = none, 1.0 = very blocky)

/*
* Helper function: Sample the original image
* Just reads the color from the original texture at the given UV coordinate
*/
vec3 bg(vec2 uv) {
    return texture2D(tDiffuse, uv).rgb; // Get RGB color from original image
}

/*
* Main pixelation effect function
* This is where the magic happens - it converts smooth gradients into pixel blocks
*/
vec3 effect(vec2 uv, vec3 col) {
    /*
    * STEP 1: Calculate pixel block size
    * intensity controls how blocky the effect is:
    * - intensity = 0.0 → granularity = 10 (small blocks, subtle effect)
    * - intensity = 1.0 → granularity = 30 (large blocks, very pixelated)
    */
    float granularity = floor(intensity * 20.0 + 10.0);
    
    /*
    * STEP 2: Ensure even block sizes
    * Even numbers create more consistent square blocks
    * Odd numbers can create slightly irregular patterns
    */
    if (mod(granularity, 2.0) > 0.0) {
        granularity += 1.0; // Make it even if it's odd
    }
    
    // Only apply pixelation if we have a meaningful block size
    if (granularity > 0.0) {
        /*
        * STEP 3: Convert pixel size to UV space
        * UV coordinates go from 0 to 1, but we need to know how big
        * each pixel block should be in UV coordinates
        */
        float dx = granularity / u_resolution.x; // Block width in UV space
        float dy = granularity / u_resolution.y; // Block height in UV space
        
        /*
        * STEP 4: Snap UV coordinates to block centers
        * This is the core of the pixelation effect:
        * 1. floor(uv.x / dx) finds which block we're in (like grid coordinates)
        * 2. + 0.5 moves to the center of that block
        * 3. * dx converts back to UV coordinates
        *
        * Result: Instead of sampling at the exact pixel location,
        * we sample from the center of the pixel block
        */
        uv=vec2(
            dx*(floor(uv.x/dx)+.5),// Snap X to block center
            dy*(floor(uv.y/dy)+.5)// Snap Y to block center
        );
        
        // Sample the original image at the snapped coordinates
        return bg(uv);
    }
    
    // If granularity is 0, return the original color unchanged
    return col;
}

void main(){
    // Get the original color at this pixel
    vec3 tex=bg(vUv);
    
    // Apply the pixelation effect
    vec3 col=effect(vUv,tex);
    
    // Output the final pixelated color with full opacity
    gl_FragColor=vec4(col,1.);
}
