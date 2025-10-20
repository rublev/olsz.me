import antfu from '@antfu/eslint-config'
import betterTW from 'eslint-plugin-better-tailwindcss'
import eslintPluginCommentLength from 'eslint-plugin-comment-length'
import nuxt from './.nuxt/eslint.config.mjs'

/* https://github.com/schoero/eslint-plugin-better-tailwindcss/blob/56aa614b8264b6ce2814c0b99252e55b58b5520a/docs/parsers/vue.md */
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
        attributes: [
          'class',
          'className',
          'enter-active-class',
          'leave-active-class',
          'enter-from-class',
          'enter-to-class',
          'leave-from-class',
          'leave-to-class',
        ],
      },
    },
    rules: {
      /* Enable comprehensive Tailwind CSS linting */
      ...betterTW.configs['recommended-error'].rules,
      'eslint-comments/no-unlimited-disable': 'off',
      /**
       * keeping this here but commented because i'm definitely going to forget
       * how to do this in the future
       */
      'better-tailwindcss/no-unregistered-classes': [
        'error',
        {
          ignore: [
            '^pixel-rounded',
            '^xerox$',
            '^svg-filter--hidden$',
            '^selection',
          ],
        },
      ],
      /**
       * if using prettier enable this and set eslint + prettier print width to
       * the same size:
       * https://github.com/schoero/eslint-plugin-better-tailwindcss/issues/45
       * https://github.com/schoero/eslint-plugin-better-tailwindcss/issues/57
       */
      // 'better-tailwindcss/enforce-consistent-line-wrapping': 'off',
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
          ignoreUrls: true,
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
  // vue rules / should come after antfu
  {
    files: ['**/*.vue'],
    rules: {
      'vue/no-multiple-template-root': 'off',
      'vue/multi-word-component-names': 'off',
      'eslint-comments/no-unlimited-disable': 'off',
      'vue/block-order': [
        'error',
        {
          order: ['script', 'template', 'style'],
        },
      ],
      'vue/singleline-html-element-content-newline': [
        'error',
        {
          ignoreWhenNoAttributes: true,
          ignoreWhenEmpty: true,
          ignores: ['pre', 'textarea'],
        },
      ],
      'vue/max-attributes-per-line': [
        'error',
        {
          singleline: { max: 3 },
          multiline: { max: 1 },
        },
      ],
    },
  },
)
