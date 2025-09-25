import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: [
    '@nuxt/devtools',
    '@nuxt/fonts',
    '@nuxt/icon',
    '@nuxt/image',
    '@nuxt/scripts',
    '@nuxt/ui',
    '@vueuse/nuxt',
    '@nuxt/eslint',
    'nuxt-eslint-auto-explicit-import',
  ],
  fonts: {
    defaults: {
      weights: [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000],
      styles: ['normal', 'italic'],
    },
    families: [
      { name: 'Syne', provider: 'google' },
      { name: 'JetBrains Mono', provider: 'google' },
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
  vite: { plugins: [tailwindcss()] },
  css: ['./app/assets/css/main.css'],
  icon: {
    customCollections: [
      {
        prefix: 'svg',
        dir: './app/assets/icons',
      },
    ],
  },
})
