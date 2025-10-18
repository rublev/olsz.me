<script setup lang="ts"></script>

<template>
  <div class="relative min-h-screen">
    <!-- orpheus pinned to the bottom of the page -->
    <div class="pointer-events-none fixed inset-x-0 bottom-0 z-0">
      <img
        src="/assets/animations/orpheus.gif"
        alt=""
        class="h-auto w-full"
        style="image-rendering: pixelated"
      >
    </div>

    <!-- content -->
    <main class="relative z-10 flex min-h-screen flex-grow justify-center p-12">
      <!-- <Header /> -->
      <slot />
      <!-- <Footer class="mt-auto" /> -->
    </main>

    <!-- vignette overlay -->
    <PixelatedVignette :pixel-size="8" :intensity="0.075" color="#000000" />
  </div>
</template>
