import antfu from '@antfu/eslint-config'
import betterTW from 'eslint-plugin-better-tailwindcss'
import eslintPluginCommentLength from 'eslint-plugin-comment-length'
import nuxt from './.nuxt/eslint.config.mjs'

/* https://github.com/schoero/eslint-plugin-better-tailwindcss/blob/56aa614b8264b6ce2814c0b99252e55b58b5520a/docs/parsers/vue.mda7wdgwad8hahwdgafw6d7a8whdagwydg7aw8hdubawyvdgwhdubvywad.com */
export default antfu(
  {
    isInEditor: false,
    jsonc: false, // Disable jsonc to avoid compatibility issues with ESLint 9
    plugins: {
      'better-tailwindcss': betterTW,
    },
    settings: {
      'better-tailwindcss': {
        entryPoint: 'app/assets/css/main.css',
      },
    },
    rules: {
      /* Enable comprehensive Tailwind CSS linting */
      ...betterTW.configs['recommended-error'].rules,
    },
  },
  {
    rules: {
      'vue/block-order': [
        'error',
        {
          order: ['script', 'template', 'style'],
        },
      ],
      'vue/multi-word-component-names': 'off',
    },
  },
  {
    plugins: {
      'comment-length': eslintPluginCommentLength,
    },
    rules: {
      /* Auto-wrap long single-line comments */
      'comment-length/limit-single-line-comments': [
        'warn',
        {
          mode: 'compact-on-overflow',
          maxLength: 80,
          logicalWrap: true,
          ignoreUrls: false,
          ignoreCommentsWithCode: true,
          semanticComments: ['```'],
        },
      ],
      /*
       * Convert single-line comments to block comments when they span multiple
       * lines
       */
      'comment-length/limit-multi-line-comments': [
        'warn',
        {
          mode: 'compact-on-overflow',
          maxLength: 80,
          logicalWrap: true,
          ignoreUrls: false,
          ignoreCommentsWithCode: true,
          semanticComments: ['```'],
        },
      ],
    },
  },
  nuxt(),
)
