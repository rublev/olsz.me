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
  future: {
    compatibilityVersion: 4,
  },
  compatibilityDate: '2025-05-20',
  eslint: {
    config: {
      standalone: false,
    },
  },
  devtools: { enabled: true },
  typescript: {
    typeCheck: true,
    strict: true,
  },
  ui: {
    theme: {
      colors: [
        'primary',
        'secondary',
        'tertiary',
        'info',
        'success',
        'warning',
        'error',
      ],
    },
  },
  css: ['~/assets/css/main.css'],
})
