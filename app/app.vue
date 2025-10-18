<script setup lang="ts">
useHead({
  bodyAttrs: {
    class: 'antialiased min-h-screen bg-background text-foreground font-sans',
  },
})
</script>

<template>
  <NuxtRouteAnnouncer />
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
