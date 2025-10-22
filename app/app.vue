<script setup lang="ts">
useHead({
  bodyAttrs: {
    class: 'min-h-svh bg-background font-sans text-foreground',
  },
  script: [
    {
      innerHTML: `
        (function() {
          const theme = sessionStorage.getItem('theme') ||
                       (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
          if (theme === 'dark') {
            document.documentElement.classList.add('dark');
          }
        })();
      `,
      tagPosition: 'head',
    },
  ],
})
</script>

<template>
  <NuxtRouteAnnouncer />
  <SvgFilters />

  <NuxtLoadingIndicator />
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
