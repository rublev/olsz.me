<script setup lang="ts">
interface Props {
  /* Icon name for the left icon (e.g., 'svg:rocket') */
  icon: string
  /* First part of the job string (e.g., 'building startups') */
  title: string
  /* Company URL */
  companyUrl?: string
  /* Company title/domain (e.g., 'stratosphere.digital') */
  companyTitle?: string
  /* Technology tags */
  tags: string[]
  /* Optional GitHub repository URL */
  githubUrl?: string
  /* Optional suffix string (e.g., 'acq by <a>coinbase</a>') */
  suffix?: string
  /* Optional Product Hunt URL */
  productHuntUrl?: string
  /* Optional flame icon URL (for featured/special projects) */
  flameUrl?: string
  /* Whether the project is disabled/unavailable */
  disabled?: boolean
}

defineProps<Props>()
</script>

<template>
  <div
    class="flex items-stretch"
    :class="{ 'pointer-events-none': disabled }"
  >
    <div
      class="
        flex w-full items-center gap-3 bg-black p-2 pr-3
        md:gap-2
      "
    >
      <!-- Left Icon -->
      <Icon
        :name="icon"
        class="
          h-6 w-6 shrink-0
          md:h-4 md:w-4
        "
        :color="disabled ? 'gray' : 'lime'"
      />

      <!-- Content -->
      <div class="flex-1">
        <!-- Title and Company -->
        <div
          class="
            pt-0.5 font-04b03 text-sm leading-none
            md:leading-1
          "
          :class="{ 'text-gray-500': disabled }"
        >
          {{ title }}
          <template v-if="companyUrl && companyTitle">
            <span> @ </span>
            <component
              :is="disabled ? 'span' : 'a'"
              :href="disabled ? undefined : companyUrl"
              :target="disabled ? undefined : '_blank'"
              :class="disabled ? '' : 'underline'"
            >
              {{ companyTitle }}
            </component>
          </template>
          <template v-if="suffix">
            <span v-html="suffix" />
          </template>
        </div>
      </div>
    </div>

    <!-- GitHub Icon (inside box, far right) -->
    <component
      :is="disabled ? 'div' : 'a'"
      v-if="githubUrl"
      :href="disabled ? undefined : githubUrl"
      :target="disabled ? undefined : '_blank'"
      class="
        flex w-full max-w-8 items-center justify-center border-l-2 border-matrix
        bg-black
      "
    >
      <Icon
        name="svg:github"
        class="h-full w-auto p-1.5"
        :color="disabled ? 'gray' : 'lime'"
      />
    </component>
    <!-- Product Hunt Icon (outside box) -->
    <component
      :is="disabled ? 'div' : 'a'"
      v-if="productHuntUrl"
      :href="disabled ? undefined : productHuntUrl"
      :target="disabled ? undefined : '_blank'"
      class="
        flex w-full max-w-8 items-center justify-center border-l-2 border-matrix
        bg-black
      "
    >
      <Icon
        name="svg:flame"
        class="h-full w-auto p-1.5"
        :color="disabled ? 'gray' : 'lime'"
      />
    </component>

    <!-- Flame Icon (outside box) -->
    <component
      :is="disabled ? 'div' : 'a'"
      v-if="flameUrl"
      :href="disabled ? undefined : flameUrl"
      :target="disabled ? undefined : '_blank'"
      class="
        flex w-full max-w-8 items-center justify-center border-l-2 border-matrix
        bg-black
      "
    >
      <Icon
        name="svg:trophy"
        class="h-full w-auto p-1.5"
        :color="disabled ? 'gray' : 'lime'"
      />
    </component>
  </div>
</template>
