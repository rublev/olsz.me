[![code style](https://antfu.me/badge-code-style.svg)](https://github.com/antfu/eslint-config)

# Nuxt Minimal Starter

Look at the [Nuxt documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.

## Setup

Make sure to install dependencies:

```bash
# npm
npm install
# pnpm
pnpm install
# yarn
yarn install
# bun
bun install
```

## Development Server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev
# pnpm
pnpm dev
# yarn
yarn dev
# bun
bun run dev
```

## Production

Build the application for production:

```bash
# npm
npm run build
# pnpm
pnpm build
# yarn
yarn build
# bun
bun run build
```

Locally preview production build:

```bash
# npm
npm run preview
# pnpm
pnpm preview
# yarn
yarn preview
# bun
bun run preview
```

Check out the [deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information.

## Todo

- [ ] eventually replace `"shadcn-nuxt": "https://pkg.pr.new/shadcn-nuxt@1418",` when the "Two components" bug is fixed:
  - https://github.com/unovue/shadcn-vue/issues/1416

- [ ] check back on this eslint-plugin-better-tailwindcss thread:
  - https://github.com/schoero/eslint-plugin-better-tailwindcss/issues/228

- [ ] figure out why disabling entryPoint for better-tailwindcss solves all my "unregistered class" problems???
  - https://github.com/schoero/eslint-plugin-better-tailwindcss/issues/228

- [ ] eventually remove explicit `eslint.config.ts` flag in `package.json` once ESLint >9 recognizes `.ts` config files natively

- [ ] figure out why `'import-notation': 'string'` in ./stylelint.config.js is necessary for better-tailwindcss not to break, aka why @import url("") breaks stylelint. thank god for @nuxt/fonts removing the need to have google fonts import via url
