<script setup lang="ts">
useHead({
  bodyAttrs: {
    class: 'min-h-dvh bg-background font-sans text-foreground',
  },
})
</script>

<template>
  <NuxtRouteAnnouncer />
  <SvgFilters />

  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
