<script setup lang="ts">
interface Props {
  /** Icon name for the left icon (e.g., 'svg:rocket') */
  icon: string
  /** First part of the job string (e.g., 'building startups') */
  title: string
  /** Company URL */
  companyUrl?: string
  /** Company title/domain (e.g., 'stratosphere.digital') */
  companyTitle?: string
  /** Technology tags */
  tags: string[]
  /** Optional GitHub repository URL */
  githubUrl?: string
  /** Optional suffix string (e.g., 'acq by <a>coinbase</a>') */
  suffix?: string
  /** Optional Product Hunt URL */
  productHuntUrl?: string
  /** Optional flame icon URL (for featured/special projects) */
  flameUrl?: string
}

defineProps<Props>()
</script>

<template>
  <div class="flex items-stretch">
    <div class="flex w-full items-center gap-2 bg-black p-2 pr-3">
      <!-- Left Icon -->
      <Icon :name="icon" class="h-4 w-4 flex-shrink-0" color="lime" />

      <!-- Content -->
      <div class="flex-1">
        <!-- Title and Company -->
        <div class="font-4b text-sm leading-1">
          {{ title }}
          <template v-if="companyUrl && companyTitle">
            <span> @ </span>
            <a :href="companyUrl" target="_blank" class="underline">
              {{ companyTitle }}
            </a>
          </template>
          <template v-if="suffix">
            <span v-html="suffix" />
          </template>
        </div>

        <!-- Tech Tags -->
        <!-- <div class="font-4b text-sm leading-none">
            {{ tags.join(" / ") }}
          </div> -->
      </div>
    </div>

    <!-- GitHub Icon (inside box, far right) -->
    <a
      v-if="githubUrl"
      :href="githubUrl"
      target="_blank"
      class="
        flex w-full max-w-8 items-center justify-center border-l-2 border-matrix
        bg-black
      "
    >
      <Icon name="svg:github" class="h-full w-auto p-1.5" color="lime" />
    </a>
    <!-- Product Hunt Icon (outside box) -->
    <a
      v-if="productHuntUrl"
      :href="productHuntUrl"
      target="_blank"
      class="
        flex w-full max-w-8 items-center justify-center border-l-2 border-matrix
        bg-black
      "
    >
      <Icon name="svg:flame" class="h-full w-auto p-1.5" color="lime" />
    </a>

    <!-- Flame Icon (outside box) -->
    <a
      v-if="flameUrl"
      :href="flameUrl"
      target="_blank"
      class="
        flex w-full max-w-8 items-center justify-center border-l-2 border-matrix
        bg-black
      "
    >
      <Icon name="svg:trophy" class="h-full w-auto p-1.5" color="lime" />
    </a>
  </div>
</template>
