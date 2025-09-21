/*
* SIMPLEX NOISE SHADER
*
* This is a mathematical noise function that creates organic, random-looking patterns.
* Think of it like the static on an old TV, but smoother and more natural.
*
* Simplex noise is better than regular noise because:
* - It's smoother and more organic looking
* - It doesn't create grid-like artifacts
* - It's computationally efficient on GPUs
*
* This implementation is based on Stefan Gustavson's work.
* You don't need to understand every line - just know it creates smooth random values.
*/

// Helper function: Keep numbers within a specific range (0 to 289)
// This prevents mathematical overflow and ensures the noise repeats predictably
vec3 mod289(vec3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0; // Wrap values to stay under 289
}

// Same as above but for 2D vectors
vec2 mod289(vec2 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0; // Keep 2D coordinates in range
}

// Create pseudo-random permutations for noise generation
// This scrambles the input values to create randomness
vec3 permute(vec3 x) {
    return mod289((x * 34.0 + 1.0) * x); // Mathematical permutation formula
}

/*
* MAIN NOISE FUNCTION
* Input: 2D coordinate (like x,y position)
* Output: Smooth random value between -1 and 1
*/
float snoise(vec2 v){
    // Mathematical constants for simplex noise algorithm
    // These specific numbers create the optimal simplex grid
    const vec4 C=vec4(
        .211324865405187,// (3.0 - sqrt(3.0)) / 6.0 - used for skewing
        .366025403784439,// 0.5 * (sqrt(3.0) - 1.0) - grid transformation
        -.577350269189626,// -1.0 + 2.0 * C.x - offset calculation
        .024390243902439// 1.0 / 41.0 - final scaling factor
    );
    
    // STEP 1: Transform input coordinate to simplex grid
    vec2 i=floor(v+dot(v,C.yy));// Skew input space to simplex grid
    vec2 x0=v-i+dot(i,C.xx);// Unskew back to get relative position
    
    // STEP 2: Determine which simplex triangle we're in
    // A simplex is divided into triangles - figure out which one we're in
    vec2 i1;
    i1=x0.x>x0.y?vec2(1.,0.):vec2(0.,1.);// Choose triangle based on which coordinate is larger
    
    // STEP 3: Calculate offsets to the three simplex corners
    vec4 x12=x0.xyxy+C.xxzz;// Offsets to other corners
    x12.xy-=i1;// Adjust for the middle corner
    
    // STEP 4: Generate random gradients for each corner
    i=mod289(i);// Keep grid coordinates in range
    vec3 p=permute(permute(i.y+vec3(0.,i1.y,1.))+i.x+vec3(0.,i1.x,1.));// Create permutation for each corner
    
    // STEP 5: Calculate falloff weights for each corner
    // Points closer to corners have more influence
    vec3 m=max(.5-vec3(dot(x0,x0),dot(x12.xy,x12.xy),dot(x12.zw,x12.zw)),0.);// Distance-based falloff
    m=m*m;// Square the falloff
    m=m*m;// Square again for smoother falloff
    
    // STEP 6: Calculate gradient vectors and final contributions
    vec3 x=2.*fract(p*C.www)-1.;// Create gradient vectors from permutation
    vec3 h=abs(x)-.5;// Helper for gradient calculation
    vec3 ox=floor(x+.5);// Round to nearest integer
    vec3 a0=x-ox;// Get fractional part
    
    // STEP 7: Normalize gradients and apply distance falloff
    m*=1.79284291400159-.85373472095314*(a0*a0+h*h);// Normalize implicit gradients
    
    // STEP 8: Calculate final gradient contributions
    vec3 g;
    g.x=a0.x*x0.x+h.x*x0.y;// Gradient contribution from first corner
    g.yz=a0.yz*x12.xz+h.yz*x12.yw;// Gradient contributions from other corners
    
    // STEP 9: Sum all contributions and scale to final range
    return 130.*dot(m,g);// Scale and return final noise value (-1 to 1)
}
