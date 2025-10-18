<script setup lang="ts">
useHead({
  bodyAttrs: {
    class: 'min-h-screen bg-background font-sans text-foreground antialiased',
  },
})
</script>

<template>
  <NuxtRouteAnnouncer />
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
