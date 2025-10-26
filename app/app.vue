<script setup lang="ts">
const { isDark } = useTheme()

useHead({
  bodyAttrs: {
    class: 'min-h-svh bg-background font-sans text-foreground',
  },
  link: [
    {
      rel: 'icon',
      type: 'image/x-icon',
      href: computed(() =>
        isDark.value ? '/favicon-magenta.ico' : '/favicon-lime.ico',
      ),
    },
  ],
})
</script>

<template>
  <NuxtRouteAnnouncer />
  <SvgFilters />

  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
