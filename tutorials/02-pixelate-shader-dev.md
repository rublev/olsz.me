# Pixelate Shader Implementation Tutorial

This tutorial explains how we implemented a pixelate post-processing effect for the gradient demo, converting a Three.js JavaScript shader into GLSL files and integrating it into a rendering pipeline.

## Overview

The pixelate shader creates a "low pixel" or retro aesthetic by quantizing the screen into larger pixel blocks. Instead of rendering each individual pixel with its own color, we group pixels into blocks and sample the color from the center of each block.

## Step 1: Converting JavaScript Shader to GLSL Files

### Original Three.js Shader Structure

The original shader was defined as a JavaScript object with vertex and fragment shader code stored as string arrays:

```javascript
THREE.PixelateShader = {
  uniforms: {
    tDiffuse: { value: null },
    intensity: { value: 1.0 },
  },
  vertexShader: [
    /* vertex code */
  ].join('\n'),
  fragmentShader: [
    /* fragment code */
  ].join('\n'),
}
```

### Extracted Vertex Shader (`pixelate-vertex.glsl`)

```glsl
varying vec2 vUv;

void main() {
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
```

**What it does:**

- Takes the vertex UV coordinates and passes them to the fragment shader via `varying vec2 vUv`
- Transforms the vertex position using standard Three.js transformation matrices
- This is a standard fullscreen quad vertex shader for post-processing

### Extracted Fragment Shader (`pixelate-fragment.glsl`)

```glsl
varying vec2 vUv;
uniform sampler2D tDiffuse;
uniform vec2 u_resolution;
uniform float intensity;

vec3 bg(vec2 uv) {
  return texture2D(tDiffuse, uv).rgb;
}

vec3 effect(vec2 uv, vec3 col) {
  float granularity = floor(intensity * 20.0 + 10.0);
  if (mod(granularity, 2.0) > 0.0) {
    granularity += 1.0;
  }
  if (granularity > 0.0) {
    float dx = granularity / u_resolution.x;
    float dy = granularity / u_resolution.y;
    uv = vec2(dx * (floor(uv.x / dx) + 0.5), dy * (floor(uv.y / dy) + 0.5));
    return bg(uv);
  }
  return col;
}

void main() {
  vec3 tex = bg(vUv);
  vec3 col = effect(vUv, tex);
  gl_FragColor = vec4(col, 1.0);
}
```

**How the pixelation works:**

1. **Granularity Calculation**: `floor(intensity * 20.0 + 10.0)` determines pixel block size
2. **Even Granularity**: Ensures granularity is even for consistent blocks
3. **UV Quantization**:
   - `dx = granularity / u_resolution.x` - pixel size in UV space (x-axis)
   - `dy = granularity / u_resolution.y` - pixel size in UV space (y-axis)
   - `floor(uv.x / dx) + 0.5` - snaps UV to block centers
4. **Texture Sampling**: Samples the original texture at quantized coordinates

## Step 2: Post-Processing Pipeline Setup

### Render Targets

```javascript
const renderTarget = new THREE.WebGLRenderTarget(
  window.innerWidth,
  window.innerHeight,
)
const postScene = new THREE.Scene()
const postCamera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1)
```

**Why we need this:**

- `renderTarget`: Captures the original gradient render into a texture
- `postScene`: Separate scene for post-processing effects
- `postCamera`: Orthographic camera covers the entire screen (-1 to 1 in both axes)

### Post-Processing Material

```javascript
const pixelateMaterial = new THREE.ShaderMaterial({
  uniforms: {
    tDiffuse: { value: null }, // Input texture
    u_resolution: {
      value: new THREE.Vector2(window.innerWidth, window.innerHeight),
    },
    intensity: { value: 0.3 }, // Pixelation strength
  },
  vertexShader: pixelateVertexShader,
  fragmentShader: pixelateFragmentShader,
})
```

### Fullscreen Quad

```javascript
const postGeometry = new THREE.PlaneGeometry(2, 2) // 2x2 covers -1 to 1
const postMesh = new THREE.Mesh(postGeometry, pixelateMaterial)
postScene.add(postMesh)
```

## Step 3: Rendering Pipeline

### Two-Pass Rendering

```javascript
function animate() {
  // Pass 1: Render original scene to texture
  renderer.setRenderTarget(renderTarget)
  renderer.render(scene, camera)

  // Pass 2: Apply pixelate effect to captured texture
  pixelateMaterial.uniforms.tDiffuse.value = renderTarget.texture
  renderer.setRenderTarget(null) // Render to screen
  renderer.render(postScene, postCamera)

  // ... rest of animation logic
}
```

**The Pipeline:**

1. **First Pass**: Render the gradient scene to `renderTarget`
2. **Texture Binding**: Pass the captured texture to the pixelate shader
3. **Second Pass**: Render the fullscreen quad with pixelate effect to screen

## Key Concepts Explained

### UV Coordinate System

- UV coordinates go from (0,0) to (1,1) across the texture
- We quantize these coordinates to create pixel blocks
- `floor(uv.x / dx) + 0.5` snaps to block centers

### Granularity and Block Size

- Higher `intensity` = smaller blocks = more pixelated
- `granularity / resolution` converts pixel size to UV space
- Even granularity ensures consistent block shapes

### Post-Processing vs Direct Rendering

- **Direct**: Apply effect during main render (limited)
- **Post-processing**: Apply effect to completed render (flexible)
- Allows layering multiple effects and preserves original render

### Orthographic Camera for Post-Processing

- No perspective distortion
- Maps directly to screen coordinates
- Perfect for fullscreen effects

## Why This Approach Works

1. **Modularity**: Shader files are reusable and maintainable
2. **Performance**: Single pass per effect, GPU-accelerated
3. **Flexibility**: Easy to adjust intensity and add more effects
4. **Clean Separation**: Original scene logic unchanged

## Potential Enhancements

- **Dynamic Intensity**: Animate intensity based on time or user input
- **Multiple Effects**: Chain with other post-processing effects
- **Adaptive Quality**: Adjust granularity based on screen resolution
- **Color Quantization**: Reduce color palette for authentic retro look

This implementation demonstrates the power of post-processing pipelines for visual effects that would be difficult or impossible to achieve during the main rendering pass.
