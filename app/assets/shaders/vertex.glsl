/*
* GRADIENT MESH VERTEX SHADER
*
* This shader creates a wavy, distorted mesh by moving vertices using noise.
* Think of it like taking a flat piece of fabric and making it ripple in the wind.
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
    * NOISE-BASED DISTORTION
    * We use two different noise calculations to create organic wave-like movement:
    * 1. Z-axis distortion (depth/height waves)
    * 2. X-axis distortion (left/right waves)
    */
    
    // Create smooth, flowing wave distortion using simple mathematical functions
    // No noise - just smooth sine/cosine waves for gentle, flowing movement
    
    // Smooth flowing wave based on position and time
    float wave1=sin(vUv.x*3.14+u_time*.5)*cos(vUv.y*2.5+u_time*.3);
    float wave2=cos(vUv.x*2.8+u_time*.4)*sin(vUv.y*3.2+u_time*.6);
    
    // Combine smooth waves
    vDistortion=(wave1+wave2)*.5;
    
    // Smooth X distortion using different wave pattern
    float xDistortion=sin(vUv.y*2.+u_time*.7)*.8;
    
    // Start with the original vertex position
    vec3 pos=position;
    
    // Move vertex up/down (Z-axis) based on main distortion
    // Multiply by 35.0 to make the waves more dramatic
    pos.z+=vDistortion*35.;
    
    // Move vertex left/right (X-axis) based on secondary distortion
    // Multiply by 25.0 for moderate horizontal movement
    pos.x+=xDistortion*25.;
    
    // Transform the modified position to screen coordinates
    // This is the standard vertex transformation pipeline
    gl_Position=projectionMatrix*modelViewMatrix*vec4(pos,1.);
}
