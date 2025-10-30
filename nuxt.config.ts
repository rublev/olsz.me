import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  ssr: false,
  app: {
    head: {
      title: 'Marcel - Full Stack Developer & Designer',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        {
          name: 'description',
          content:
            'Full Stack developer & designer working mostly with early to mid-stage startups. Currently working on a few fun projects and looking for my next exciting role!',
        },
        // Open Graph
        { property: 'og:type', content: 'website' },
        {
          property: 'og:title',
          content: 'Marcel - Full Stack Developer & Designer',
        },
        {
          property: 'og:description',
          content:
            'Full Stack developer & designer working mostly with early to mid-stage startups. Currently working on a few fun projects and looking for my next exciting role!',
        },
        { property: 'og:site_name', content: 'Marcel' },
        // Twitter Card
        { name: 'twitter:card', content: 'summary_large_image' },
        {
          name: 'twitter:title',
          content: 'Marcel - Full Stack Developer & Designer',
        },
        {
          name: 'twitter:description',
          content:
            'Full Stack developer & designer working mostly with early to mid-stage startups. Currently working on a few fun projects and looking for my next exciting role!',
        },
      ],
      link: [
        /*
        * compressed all favicons (5 sizes) into one file:
          magick favicon-16x16-lime.png favicon-32x32-border.png \
          favicon-64x64-border.png favicon-128x128-border.png \
          favicon-256x256-border.png -colors 256 favicon.ico
        */
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      ],
      script: [
        {
          'defer': true,
          'src': 'https://umami-omega-eight-83.vercel.app/script.js',
          'data-website-id': 'fac1fd6f-b4e8-4210-bc41-842f20a93cb3',
        },
      ],
    },
  },
  modules: ['@nuxt/eslint', '@nuxt/fonts', '@nuxt/icon', '@vueuse/nuxt'],
  // ignore: ['app/pages/demos/**'],
  vueuse: {
    // Only auto-import specific VueUse functions you actually use
    ssrHandlers: false,
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
    serverBundle: false, // Disable server-side icon bundling to reduce SSR bundle
    clientBundle: {
      // Only bundle icons that are actually used on the client
      scan: true,
      sizeLimitKb: 512,
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
