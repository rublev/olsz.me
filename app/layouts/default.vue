<script setup lang="ts"></script>

<template>
  <div class="relative min-h-dvh">
    <!-- cool darkened -->
    <!-- <div class="absolute z-1 h-full w-full bg-black mix-blend-overlay" /> -->
    <!-- <div class="absolute z-1 h-full w-full bg-matrix mix-blend-saturation" /> -->

    <!-- color dodge night -->
    <div class="absolute z-1 h-full w-full bg-matrix mix-blend-color-dodge" />
    <div class="absolute z-1 h-full w-full bg-matrix mix-blend-exclusion" />

    <!-- orpheus pinned to the bottom of the page -->
    <div
      class="
        pointer-events-none fixed inset-0 z-0 flex items-center justify-center
      "
    >
      <img
        src="/assets/animations/orpheus.gif"
        alt=""
        class="
          h-full w-auto object-cover object-left
          md:h-full md:min-w-[1280px] md:object-center
        "
        style="image-rendering: pixelated"
      >
    </div>

    <!-- content -->
    <main
      class="
        relative z-100 flex min-h-dvh flex-grow items-center justify-center
        md:mr-12
      "
    >
      <!-- <Header /> -->
      <slot />
      <!-- <Footer class="mt-auto" /> -->
    </main>

    <!-- vignette overlay -->
    <PixelatedVignette
      :pixel-size="8"
      :intensity="0.075"
      color="#000000"
    />
  </div>
</template>
