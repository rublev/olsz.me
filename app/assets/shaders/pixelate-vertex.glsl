/*
* PIXELATE EFFECT VERTEX SHADER
*
* This is a simple "pass-through" vertex shader for post-processing effects.
* It just sets up a fullscreen rectangle and passes coordinates to the fragment shader.
* The real pixelate magic happens in the fragment shader.
*/

// Output to fragment shader - UV coordinates for texture sampling
varying vec2 vUv; // Texture coordinates (0,0 to 1,1 across the surface)

void main() {
    // Pass the UV coordinates unchanged to the fragment shader
    // These tell the fragment shader where we are on the surface
    vUv = uv;
    
    /*
    * STANDARD VERTEX TRANSFORMATION
    * Transform the vertex position to screen coordinates
    *
    * This is the standard graphics pipeline transformation:
    * 1. position: The vertex position in 3D space
    * 2. modelViewMatrix: Transforms from object space to camera space
    * 3. projectionMatrix: Transforms from camera space to screen space
    * 4. gl_Position: Final position on screen (required output)
    */
    gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.);
}
