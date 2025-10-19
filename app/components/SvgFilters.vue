<script setup lang="ts"></script>

<template>
  <!-- SVG Filters for xerox effect -->
  <!-- Source: https://endtimes.dev/why-your-website-should-be-under-14kb-in-size/ -->
  <svg class="hidden" xmlns="http://www.w3.org/2000/svg">
    <filter id="x">
      <feTurbulence baseFrequency="0.01 0.02" numOctaves="2" result="t0" />
      <feDisplacementMap
        in="SourceGraphic"
        in2="t0"
        result="d0"
        scale="4"
      />
      <feComposite
        in="SourceGraphic"
        in2="d0"
        operator="atop"
        result="0"
      />
      <feTurbulence baseFrequency="1" numOctaves="2" result="t1" />
      <feDisplacementMap
        in="0"
        in2="t1"
        result="d1"
        scale="1"
      />
      <feComposite
        in="0"
        in2="d1"
        operator="atop"
        result="1"
      />
      <feOffset dx="-3" dy="-3" in="1" />
    </filter>
  </svg>
</template>
