<script setup>
import { useHead } from '#app/composables/head'

useHead({
  htmlAttrs: {
    class: 'dark',
  },
})
</script>

<template>
  <NuxtRouteAnnouncer />
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
