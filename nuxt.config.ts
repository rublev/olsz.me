import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: [
    '@nuxt/devtools',
    '@nuxt/fonts',
    '@nuxt/image',
    '@nuxt/scripts',
    '@nuxt/ui',
    '@vueuse/nuxt',
    '@nuxt/eslint',
  ],
  fonts: {
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
    typeCheck: true,
    strict: true,
  },
  vite: { plugins: [tailwindcss()] },
  css: ['./app/assets/css/main.css'],
})
