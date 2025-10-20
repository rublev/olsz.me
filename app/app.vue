<script setup lang="ts">
useHead({
  bodyAttrs: {
    class: 'min-h-screen bg-background font-sans text-foreground',
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
