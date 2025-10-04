import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: [
    '@nuxt/eslint',
    '@nuxt/fonts',
    '@nuxt/image', // why does this add +20mb to my bundle size?
    '@nuxt/icon',
    '@vueuse/nuxt',
  ],
  ignore: ['app/pages/demos/**'],
  vueuse: {
    // Only auto-import specific VueUse functions you actually use
    ssrHandlers: false,
  },
  fonts: {
    defaults: {
      weights: [400, 600, 700], // Only load weights you actually use
      styles: ['normal'],
    },
    families: [
      { name: 'Syne', provider: 'google' },
      { name: 'Inter', provider: 'google' },
    ],
  },
  future: {
    compatibilityVersion: 4,
  },
  compatibilityDate: '2025-07-15',
  devtools: { enabled: false },
  eslint: {
    config: {
      standalone: false,
    },
  },
  typescript: {
    // disabled typecheck because this fixes HMR
    // https://github.com/nuxt/nuxt/issues/32564#issuecomment-3313960055
    typeCheck: false,
    strict: true,
  },
  vite: {
    plugins: [tailwindcss()],
    build: {
      sourcemap: false, // Disable sourcemaps to fix Tailwind warning
      rollupOptions: {
        output: {
          manualChunks: {
            // Split vendor libraries into separate chunks
            'vue-vendor': ['vue', 'vue-router'],
            'nuxt-vendor': ['nuxt/app'],
          },
        },
      },
    },
  },
  css: ['./app/assets/css/main.css'],
  icon: {
    // makes bundle smaller only include mdi icons
    serverBundle: {
      collections: ['mdi'],
    },
    mode: 'svg',
    customCollections: [
      {
        prefix: 'svg',
        dir: './app/assets/icons',
      },
    ],
  },
})
